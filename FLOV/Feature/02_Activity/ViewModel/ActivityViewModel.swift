//
//  ActivityViewModel.swift
//  FLOV
//
//  Created by 조우현 on 5/19/25.
//

import Foundation
import Combine

final class ActivityViewModel: ViewModelType {
    private let activityRepository: ActivityRepositoryType
    var cancellables: Set<AnyCancellable>
    var input: Input
    @Published var output: Output
    
    init(
        activityRepository: ActivityRepositoryType,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        input: Input = Input(),
        output: Output = Output()
    ) {
        self.activityRepository = activityRepository
        self.cancellables = cancellables
        self.input = input
        self.output = output
        transform()
    }
    
    struct Input {
        let fetchNewActivities = PassthroughSubject<Void, Never>()
        // 추천 액티비티(limit에 5) / 전체 액티비티(limit에 10 -> 페이지네이션)
        let fetchActivities = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var newActivities: [ActivitySummaryEntity] = []
        var allActivities: [ActivityListEntity] = []
        var ads: [AdBannerEntity] = MockDataBuilder.ads
    }
}

// MARK: - Action
extension ActivityViewModel {
    enum Action {
        case fetchAllActivities
    }
    
    func action(_ action: Action) {
        switch action {
        case .fetchAllActivities:
            input.fetchNewActivities.send(())
            input.fetchActivities.send(())
        }
    }
}

// MARK: - Transform
extension ActivityViewModel {
    func transform() {
        
        input.fetchNewActivities
            .sink { [weak self] _ in
                guard let self else { return }
                Task {
                    await self.fetchNewActivities()
                }
            }
            .store(in: &cancellables)
        
        input.fetchActivities
            .sink { [weak self] _ in
                guard let self else { return }
                self.fetchActivities()
            }
            .store(in: &cancellables)
    }

}

// MARK: - Function
extension ActivityViewModel {
    @MainActor
    private func fetchNewActivities() async {
//        do {
//            let response = try await activityRepository.newListLookup(country: nil, category: nil)
//            
//            output.newActivities = response.data
//        } catch {
//            print(error)
//        }
    }
    
    private func fetchActivities() {
        print("fetchActivities")
    }
}
