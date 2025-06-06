//
//  ChatRoomViewModel.swift
//  FLOV
//
//  Created by 조우현 on 6/3/25.
//

import Foundation
import Combine

final class ChatRoomViewModel: ViewModelType {
    private let chatRepository: ChatRepositoryType
    private let chatService: ChatServiceType
    let opponentId: String
    var chatRoomId: String?
    var cancellables: Set<AnyCancellable>
    var input: Input
    @Published var output: Output
    
    init(
        chatRepository: ChatRepositoryType,
        chatService: ChatServiceType,
        opponentId: String,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        input: Input = Input(),
        output: Output = Output()
    ) {
        self.chatRepository = chatRepository
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
    }
    
    struct Output {
        var messages: [ChatMessage] = []
    }
}

// MARK: - Action
extension ChatRoomViewModel {
    enum Action {
        case createChatRoom(String)
        case disconnectSocket
    }

    func action(_ action: Action) {
        switch action {
        case .createChatRoom(let opponentId):
            input.createChatRoom.send(opponentId)
        case .disconnectSocket:
            input.disconnectSocket.send(())
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
    }
}

// MARK: - Function
extension ChatRoomViewModel {
    private func createChatRoom(opponentId: String) async {
        do {
            let response = try await chatRepository.createChat(request: .init(opponentId: opponentId))
            chatRoomId = response.roomId
            
            await connectSocket()
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
}
