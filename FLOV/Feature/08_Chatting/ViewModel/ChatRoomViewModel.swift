//
//  ChatRoomViewModel.swift
//  FLOV
//
//  Created by 조우현 on 6/3/25.
//

import Foundation
import Combine

final class ChatRoomViewModel: ViewModelType {
    private let activityRepository: ActivityRepositoryType
    let opponentId: String
    var cancellables: Set<AnyCancellable>
    var input: Input
    @Published var output: Output
    
    init(
        activityRepository: ActivityRepositoryType,
        opponentId: String,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        input: Input = Input(),
        output: Output = Output()
    ) {
        self.activityRepository = activityRepository
        self.opponentId = opponentId
        self.cancellables = cancellables
        self.input = input
        self.output = output
        transform()
    }
    
    struct Input {

    }
    
    struct Output {

    }
}

// MARK: - Action
extension ChatRoomViewModel {
    enum Action {

    }

    func action(_ action: Action) {

    }
}

// MARK: - Transform
extension ChatRoomViewModel {
    func transform() {

    }
}

// MARK: - Function
extension ChatRoomViewModel {

}
