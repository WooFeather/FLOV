//
//  PostDetailViewModel.swift
//  FLOV
//
//  Created by 조우현 on 6/28/25.
//

import Foundation
import Combine

final class PostDetailViewModel: ViewModelType {
    private let postRepository: PostRepositoryType
    private let locationService: LocationServiceType
    var cancellables: Set<AnyCancellable>
    var input: Input
    
    @Published var output: Output
    
    init(
        postRepository: PostRepositoryType,
        locationService: LocationServiceType,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        input: Input = Input(),
        output: Output = Output()
    ) {
        self.postRepository = postRepository
        self.locationService = locationService
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
extension PostDetailViewModel {
    enum Action {
        
    }
    
    func action(_ action: Action) {
        
    }
}

// MARK: - Transform
extension PostDetailViewModel {
    func transform() {
        
    }
}

// MARK: - Private Functions
private extension PostDetailViewModel {

    
}
