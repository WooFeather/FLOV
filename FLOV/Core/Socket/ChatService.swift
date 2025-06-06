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
    
    // Published properties for SwiftUI
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
        
        // 1. DB에서 마지막 메시지 날짜 조회
        let lastMessageDate = await getLastMessageDate(roomId: roomId)
        let nextCursor = lastMessageDate != nil ? ISO8601DateFormatter().string(from: lastMessageDate!) : nil
        
        // 2. 서버에서 새로운 메시지 조회
        let newMessages = try await chatRepository.messageListLookup(roomId: roomId, next: nextCursor)
        
        // 3. 새로운 메시지들을 DB에 저장
        for chatRoom in newMessages {
            if let lastChat = chatRoom.lastChat {
                try await saveMessageToDB(lastChat)
            }
        }
        
        // 4. DB에서 전체 메시지 로드하여 UI 업데이트
        await loadMessagesFromDB(roomId: roomId)
        
        print("✅ Loaded \(newMessages.count) new messages")
    }
    
    // MARK: - 메시지 전송
    func sendMessage(roomId: String, content: String, files: [String]?) async throws {
        print("📤 Sending message: \(content)")
        
        // 1. HTTP로 메시지 전송
        let sendRequest = SendMessageRequest(content: content, files: files)
        _ = try await chatRepository.sendMessage(roomId: roomId, request: sendRequest)
        
        // 2. 소켓을 통해서도 메시지 전송 (실시간 알림용)
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
        
        chatMessages = Array(messages.map { $0.toEntity() })
    }
    
    private func getLastMessageDate(roomId: String) async -> Date? {
        let chatRoom = realm.object(ofType: ChatRoomObject.self, forPrimaryKey: roomId)
        return chatRoom?.lastMessageDate
    }
}
