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
        let fetchActivityDetail = PassthroughSubject<String, Never>()
        
        let didSelectCountry = PassthroughSubject<Country, Never>()
        let didSelectActivityType = PassthroughSubject<ActivityType, Never>()
    }
    
    struct Output {
        var newActivities: [ActivitySummaryEntity] = []
        var allActivities: [ActivityListEntity] = []
        var activityDetails: [String: ActivityDetailEntity] = [:]
        var ads: [AdBannerEntity] = MockDataBuilder.ads
        
        var selectedCountry: Country? = nil
        var selectedActivityType: ActivityType? = nil
    }
}

// MARK: - Action
extension ActivityViewModel {
    enum Action {
        case fetchAllActivities
        case fetchActivityDetail(id: String)
        case selectCountry(country: Country)
        case selectActivityType(type: ActivityType)
    }
    
    func action(_ action: Action) {
        switch action {
        case .fetchAllActivities:
            input.fetchNewActivities.send(())
            input.fetchActivities.send(())
        case .fetchActivityDetail(id: let id):
            input.fetchActivityDetail.send(id)
        case .selectCountry(let country):
            input.didSelectCountry.send(country)
        case .selectActivityType(let type):
            input.didSelectActivityType.send(type)
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
        
        input.fetchActivityDetail
            .sink { [weak self] id in
                guard let self else { return }
                Task {
                    await self.fetchActivityDetail(id: id)
                }
            }
            .store(in: &cancellables)
        
        input.didSelectCountry
            .sink { [weak self] country in
                guard let self = self else { return }
                if output.selectedCountry == country {
                    output.selectedCountry = nil
                } else {
                    output.selectedCountry = country
                }
                action(.fetchAllActivities)
            }
            .store(in: &cancellables)
        
        input.didSelectActivityType
            .sink { [weak self] type in
                guard let self = self else { return }
                if output.selectedActivityType == type {
                    output.selectedActivityType = nil
                } else {
                    output.selectedActivityType = type
                }
                action(.fetchAllActivities)
            }
            .store(in: &cancellables)
    }

}

// MARK: - Function
extension ActivityViewModel {
    @MainActor
    private func fetchNewActivities() async {
        do {
            let response = try await activityRepository.newListLookup(country: nil, category: nil)
            
            output.newActivities = response.data
        } catch {
            print(error)
        }
    }
    
    @MainActor
    private func fetchActivityDetail(id: String) async {
        do {
            let response = try await activityRepository.detailLookup(activityId: id)
            
            output.activityDetails[id] = response
        } catch {
            print(error)
        }
    }
    
    private func fetchActivities() {
        print("fetchActivities")
    }
}
