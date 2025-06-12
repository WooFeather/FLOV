//
//  ChatListViewModel.swift
//  FLOV
//
//  Created by 조우현 on 6/8/25.
//

import Foundation
import Combine

class ChatListViewModel: ViewModelType {
    private let chatRepository: ChatRepositoryType
    var cancellables: Set<AnyCancellable>
    var input: Input
    @Published var output: Output
    
    init(
        chatRepository: ChatRepositoryType,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        input: Input = Input(),
        output: Output = Output()
    ) {
        self.chatRepository = chatRepository
        self.cancellables = cancellables
        self.input = input
        self.output = output
        transform()
    }
    
    struct Input {
        let fetchChatList = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var isLoading = false
        var chatList: [ChatRoomEntity] = []
    }
}

// MARK: - Action
extension ChatListViewModel {
    enum Action {
        case fetchChatList
    }

    func action(_ action: Action) {
        switch action {
        case .fetchChatList:
            input.fetchChatList.send(())
        }
    }
}

// MARK: - Transform
extension ChatListViewModel {
    func transform() {
        input.fetchChatList
            .sink { [weak self] _ in
                guard let self else { return }
                
                Task {
                    await self.fetchChatList()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Function
extension ChatListViewModel {
    @MainActor
    private func fetchChatList() async {
        output.isLoading = true
        defer { output.isLoading = false }
        
        do {
            let response = try await chatRepository.chatListLookup()
            
            output.chatList = response
        } catch {
            print(error)
        }
    }
}
