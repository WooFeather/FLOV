//
//  ChatService.swift
//  FLOV
//
//  Created by 조우현 on 6/5/25.
//

import Foundation
import RealmSwift
import Combine

// MARK: - Chat Service Protocol
protocol ChatServiceType {
    func enterChatRoom(opponentId: String) async throws -> String
    func loadChatHistory(roomId: String) async throws
    func sendMessage(roomId: String, content: String, files: [String]?) async throws
    func connectSocket(roomId: String) async
    func disconnectSocket() async
    var messages: AnyPublisher<[ChatMessageEntity], Never> { get }
}

// MARK: - Chat Service Implementation
@MainActor
final class ChatService: ObservableObject, @preconcurrency ChatServiceType {
    private let chatRepository: any ChatRepositoryType
    private let socketManager: any SocketManagerType
    private let realm: Realm
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var chatMessages: [ChatMessageEntity] = []
    
    var messages: AnyPublisher<[ChatMessageEntity], Never> {
        $chatMessages.eraseToAnyPublisher()
    }
    
    init(
        chatRepository: any ChatRepositoryType,
        socketManager: any SocketManagerType = SocketManager.shared,
        realm: Realm = try! Realm()
    ) {
        self.chatRepository = chatRepository
        self.socketManager = socketManager
        self.realm = realm
        
        setupSocketMessageListener()
    }
    
    // MARK: - 채팅방 진입
    func enterChatRoom(opponentId: String) async throws -> String {
        print("🚪 Entering chat room for opponent: \(opponentId)")
        
        // 1. 채팅방 생성 또는 조회
        let createChatRequest = CreateChatRequest(opponentId: opponentId)
        let chatRoom = try await chatRepository.createChat(request: createChatRequest)
        
        // 2. 채팅방 정보를 DB에 저장
        try await saveChatRoomToDB(chatRoom)
        
        // 3. 채팅 히스토리 로드
        try await loadChatHistory(roomId: chatRoom.roomId)
        
        // 4. 소켓 연결
        await connectSocket(roomId: chatRoom.roomId)
        
        return chatRoom.roomId
    }
    
    // MARK: - 채팅 히스토리 로드
    func loadChatHistory(roomId: String) async throws {
        print("📚 Loading chat history for room: \(roomId)")

        // 0) UI에 보일 채팅 배열 초기화 (다른 채팅방 들어갔을때 대비)
        await MainActor.run { chatMessages = [] }

        // 1) DB에 저장된 메시지 중, 이 방의 마지막 메시지 날짜 가져오기
        let stored = realm.objects(ChatMessageObject.self)
            .filter("roomId == %@", roomId)
            .sorted(byKeyPath: "createdAt", ascending: true)
        let lastDateInDB = stored.last?.createdAt

        // 2) 서버 호출 시 커서: DB가 비어있다면 nil → 과거 전체를 가져옴
        let nextCursor: String? = lastDateInDB.map {
            ISO8601DateFormatter().string(from: $0)
        }

        // 3) 서버에서 “newMessages” 받아오기
        let newMessages: [ChatMessageEntity] = try await
            chatRepository.messageListLookup(roomId: roomId, next: nextCursor)

        // 4) 받은 모든 메시지를 DB에 저장
        for msg in newMessages {
            try await saveMessageToDB(msg)
        }

        // 5) DB에서 다시 불러와서 Published 프로퍼티 업데이트
        await loadMessagesFromDB(roomId: roomId)

        print("✅ Loaded \(newMessages.count) new messages (cursor: \(nextCursor ?? "nil"))")
    }
    
    // MARK: - 메시지 전송
    func sendMessage(roomId: String, content: String, files: [String]?) async throws {
        print("📤 Sending message: \(content)")
        
        // 1. HTTP로 메시지 전송하고 응답 받기
        let sendRequest = SendMessageRequest(content: content, files: files)
        let sentMessage = try await chatRepository.sendMessage(roomId: roomId, request: sendRequest)
        
        // 2. 전송된 메시지를 DB에 저장
        try await saveMessageToDB(sentMessage)
        
        // 3. UI 즉시 업데이트
        await loadMessagesFromDB(roomId: roomId)
        
        // 4. 소켓을 통해서도 메시지 전송 (실시간 알림용)
         socketManager.sendMessage(roomId: roomId, content: content)
        
        print("✅ Message sent successfully")
    }
    
    // MARK: - 소켓 연결/해제
    func connectSocket(roomId: String) async {
        await socketManager.connect(roomId: roomId)
    }
    
    func disconnectSocket() async {
        await socketManager.disconnect()
    }
    
    // MARK: - Private Methods
    
    private func setupSocketMessageListener() {
        // 소켓으로부터 메시지 수신 시 처리
        socketManager.messageReceived
            .sink { [weak self] message in
                Task { @MainActor in
                    await self?.handleReceivedMessage(message)
                }
            }
            .store(in: &cancellables)
        
        // 연결 상태 모니터링
        socketManager.connectionStatus
            .sink { status in
                print("🔌 Socket status: \(status)")
            }
            .store(in: &cancellables)
    }
    
    private func handleReceivedMessage(_ message: ChatMessageEntity) async {
        print("📥 Handling received message: \(message.content)")
        
        // 1. DB에 저장
        do {
            try await saveMessageToDB(message)
            // 2. UI 업데이트
            await loadMessagesFromDB(roomId: message.roomId)
        } catch {
            print("❌ Error handling received message: \(error)")
        }
    }
    
    private func saveChatRoomToDB(_ chatRoom: ChatRoomEntity) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            do {
                try realm.write {
                    let chatRoomObject = ChatRoomObject.from(entity: chatRoom)
                    realm.add(chatRoomObject, update: .modified)
                }
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    private func saveMessageToDB(_ message: ChatMessageEntity) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            do {
                try realm.write {
                    let messageObject = ChatMessageObject.from(entity: message)
                    realm.add(messageObject, update: .modified)
                    
                    // 채팅방의 마지막 메시지 정보 업데이트
                    if let chatRoom = realm.object(ofType: ChatRoomObject.self, forPrimaryKey: message.roomId) {
                        chatRoom.lastChatId = message.chatId
                        chatRoom.lastMessageDate = message.createdAt
                    }
                }
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    private func loadMessagesFromDB(roomId: String) async {
        let messages = realm.objects(ChatMessageObject.self)
            .filter("roomId == %@", roomId)
            .sorted(byKeyPath: "createdAt", ascending: true)
        
        // 메인 스레드에서 @Published 속성 업데이트
        await MainActor.run {
            self.chatMessages = Array(messages.map { $0.toEntity() })
            print("🔄 UI Updated with \(self.chatMessages.count) messages")
        }
    }
    
    private func getLastMessageDate(roomId: String) async -> Date? {
        let chatRoom = realm.object(ofType: ChatRoomObject.self, forPrimaryKey: roomId)
        return chatRoom?.lastMessageDate
    }
}
