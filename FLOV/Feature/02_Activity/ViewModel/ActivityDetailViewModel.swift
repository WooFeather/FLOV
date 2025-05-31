//
//  ActivityDetailViewModel.swift
//  FLOV
//
//  Created by 조우현 on 5/31/25.
//

import Foundation
import Combine

final class ActivityDetailViewModel: ViewModelType {
    private let activityRepository: ActivityRepositoryType
    private let activityId: String
    var cancellables: Set<AnyCancellable>
    var input: Input
    @Published var output: Output
    
    init(
        activityRepository: ActivityRepositoryType,
        activityId: String,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        input: Input = Input(),
        output: Output = Output()
    ) {
        self.activityRepository = activityRepository
        self.activityId = activityId
        self.cancellables = cancellables
        self.input = input
        self.output = output
        transform()
    }
    
    struct Input {
        
    }
    
    struct Output {
        var activityDetails: ActivityDetailEntity = MockDataBuilder.details
        var isLoading = false
    }
}

// MARK: - Action
extension ActivityDetailViewModel {
    enum Action {
        
    }
    
    func action(_ action: Action) {
        
    }
}

// MARK: - Transform
extension ActivityDetailViewModel {
    func transform() {
        Task {
            await fetchActivityDetail(id: activityId)
        }
    }
}

// MARK: - Function
extension ActivityDetailViewModel {
    @MainActor
    private func fetchActivityDetail(id: String) async {
        output.isLoading = true
        defer { output.isLoading = false }
        
        do {
            let response = try await activityRepository.detailLookup(activityId: id)
            
            output.activityDetails = response
        } catch {
            print(error)
        }
    }
}
