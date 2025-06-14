//
//  ChatRoomViewModel.swift
//  FLOV
//
//  Created by 조우현 on 6/3/25.
//

import Foundation
import Combine

final class ChatRoomViewModel: ViewModelType {
    private let chatService: ChatServiceType
    let opponentId: String
    var chatRoomId: String?
    var cancellables: Set<AnyCancellable>
    var input: Input
    @Published var output: Output
    
    init(
        chatService: ChatServiceType,
        opponentId: String,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        input: Input = Input(),
        output: Output = Output()
    ) {
        self.chatService = chatService
        self.opponentId = opponentId
        self.cancellables = cancellables
        self.input = input
        self.output = output
        transform()
    }
    
    struct Input {
        let createChatRoom = PassthroughSubject<String, Never>()
        let loadChatRoomInfo = PassthroughSubject<String, Never>()
        let disconnectSocket = PassthroughSubject<Void, Never>()
        let reconnectSocket = PassthroughSubject<Void, Never>()
        let sendMessage = PassthroughSubject<Void, Never>()
        let updateChatText = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var messages: [ChatMessageEntity] = []
        var chatText = ""
        var opponentInfo: UserEntity?
        var isSendButtonEnabled = false
    }
}

// MARK: - Action
extension ChatRoomViewModel {
    enum Action {
        case createChatRoom(String)
        case loadChatRoomInfo(String)
        case disconnectSocket
        case reconnectSocket
        case sendMessage
        case updateChatText(String)
    }

    func action(_ action: Action) {
        switch action {
        case .createChatRoom(let opponentId):
            input.createChatRoom.send(opponentId)
        case .loadChatRoomInfo(let opponentId):
            input.loadChatRoomInfo.send(opponentId)
        case .disconnectSocket:
            input.disconnectSocket.send(())
        case .reconnectSocket:
            input.reconnectSocket.send(())
        case .sendMessage:
            input.sendMessage.send(())
        case .updateChatText(let newText):
            input.updateChatText.send(newText)
        }
    }
}

// MARK: - Transform
extension ChatRoomViewModel {
    func transform() {
        input.createChatRoom
            .sink { [weak self] opponentId in
                guard let self = self else { return }
                
                Task {
                    await self.createChatRoom(opponentId: opponentId)
                }
            }
            .store(in: &cancellables)
        
        input.loadChatRoomInfo
            .sink { [weak self] opponentId in
                guard let self = self else { return }
                
                Task {
                    await self.loadChatRoomInfo(opponentId: opponentId)
                }
            }
            .store(in: &cancellables)
        
        input.disconnectSocket
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                Task {
                    await self.disconnectSocket()
                }
            }
            .store(in: &cancellables)
        
        input.reconnectSocket
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                Task {
                    await self.reconnectSocket()
                }
            }
            .store(in: &cancellables)
        
        chatService.messages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] messages in
                guard let self = self else { return }
                
                self.output.messages = messages
            }
            .store(in: &cancellables)
        
        input.sendMessage
            .sink { [weak self] in
                guard let self = self else { return }
                
                Task {
                    await self.sendMessage()
                }
            }
            .store(in: &cancellables)
        
        // 새로 추가: 텍스트 업데이트 처리
        input.updateChatText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newText in
                guard let self = self else { return }
                
                self.output.chatText = newText
                self.updateSendButtonState()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Function
extension ChatRoomViewModel {
    private func createChatRoom(opponentId: String) async {
        do {
            let roomId = try await chatService.enterChatRoom(opponentId: opponentId)
            chatRoomId = roomId
        } catch {
            print(error)
        }
    }
    
    @MainActor
    private func loadChatRoomInfo(opponentId: String) async {
        do {
            let chatRoom = try await chatService.loadChatRoomInfo(opponentId: opponentId)
            let currentUserId = UserSecurityManager.shared.userId
            let opponent = chatRoom.participants
                .first { $0.id != currentUserId }
                ?? chatRoom.participants.first { $0.id == currentUserId }
                ?? chatRoom.participants.first!
            output.opponentInfo = opponent
        } catch {
            print(error)
        }
    }
    
    private func connectSocket() async {
        guard let chatRoomId else { return }
        await chatService.connectSocket(roomId: chatRoomId)
    }
    
    private func disconnectSocket() async {
        await chatService.disconnectSocket()
    }
    
    private func reconnectSocket() async {
        guard let chatRoomId else { return }
        do {
           try await chatService.reconnectSocket(roomId: chatRoomId)
        } catch {
            print(error)
        }
    }
    
    @MainActor
    private func sendMessage() async {
        guard output.isSendButtonEnabled,
              let chatRoomId = chatRoomId else {
            print("❌ Cannot send empty message or missing room ID")
            return
        }
        
        let messageContent = output.chatText
        output.chatText = ""
        updateSendButtonState()
        
        do {
            try await chatService.sendMessage(roomId: chatRoomId, content: messageContent, files: nil)
        } catch {
            print("❌ Error sending message: \(error)")
            // 에러 발생 시 메시지 복원
            output.chatText = messageContent
            updateSendButtonState()
        }
    }
    
    // 전송 버튼 상태 업데이트
    private func updateSendButtonState() {
        output.isSendButtonEnabled = !output.chatText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
    }
}
