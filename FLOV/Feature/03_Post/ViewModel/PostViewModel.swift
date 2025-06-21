//
//  PostViewModel.swift
//  FLOV
//
//  Created by 조우현 on 6/21/25.
//

import Foundation
import Combine

final class PostViewModel: ViewModelType {
    var cancellables: Set<AnyCancellable>
    var input: Input
    @Published var output: Output
    
    init(
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        input: Input = Input(),
        output: Output = Output()
    ) {
        self.cancellables = cancellables
        self.input = input
        self.output = output
        transform()
    }
    
    struct Input {
        
    }
    
    struct Output {
        var ads: [AdBannerEntity] = MockDataBuilder.ads
    }
}

// MARK: - Action
extension PostViewModel {
    enum Action {
        
    }
    
    func action(_ action: Action) {
        
    }
}

// MARK: - Transform
extension PostViewModel {
    func transform() {
        
    }
}

// MARK: - Function
extension PostViewModel {
    
}
