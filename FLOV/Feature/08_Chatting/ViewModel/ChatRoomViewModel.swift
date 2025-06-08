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
        let disconnectSocket = PassthroughSubject<Void, Never>()
        let sendMessage = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var messages: [ChatMessageEntity] = []
        var chatText = ""
    }
}

// MARK: - Action
extension ChatRoomViewModel {
    enum Action {
        case createChatRoom(String)
        case disconnectSocket
        case sendMessage
    }

    func action(_ action: Action) {
        switch action {
        case .createChatRoom(let opponentId):
            input.createChatRoom.send(opponentId)
        case .disconnectSocket:
            input.disconnectSocket.send(())
        case .sendMessage:
            input.sendMessage.send(())
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
        
        input.disconnectSocket
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                Task {
                    await self.disconnectSocket()
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
    
    private func connectSocket() async {
        guard let chatRoomId else { return }
        await chatService.connectSocket(roomId: chatRoomId)
    }
    
    private func disconnectSocket() async {
        await chatService.disconnectSocket()
    }
    
    @MainActor
    private func sendMessage() async {
        guard !output.chatText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let chatRoomId = chatRoomId else {
            print("❌ Cannot send empty message or missing room ID")
            return
        }
        
        let messageContent = output.chatText
        output.chatText = ""
        
        do {
            try await chatService.sendMessage(roomId: chatRoomId, content: messageContent, files: nil)
        } catch {
            print("❌ Error sending message: \(error)")
            // 에러 발생 시 메시지 복원
            output.chatText = messageContent
        }
    }
}
