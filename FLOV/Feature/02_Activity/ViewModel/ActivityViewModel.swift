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
        let fetchRecommendedActivities = PassthroughSubject<Void, Never>()
        let fetchAllActivities = PassthroughSubject<Void, Never>()
        let fetchActivityDetail = PassthroughSubject<String, Never>()
        
        let didSelectCountry = PassthroughSubject<Country, Never>()
        let didSelectActivityType = PassthroughSubject<ActivityType, Never>()
    }
    
    struct Output {
        var newActivities: [ActivitySummaryEntity] = []
        var recommendedActivities: [ActivitySummaryEntity] = []
        var allActivities: [ActivitySummaryEntity] = []
        var activityDetails: [String: ActivityDetailEntity] = [:]
        var ads: [AdBannerEntity] = MockDataBuilder.ads
        
        var selectedCountry: Country? = nil
        var selectedActivityType: ActivityType? = nil
        
        var isLoadingNew = false
        var isLoadingRecommended = false
        var isLoadingAll = false
        var loadingDetails = Set<String>() // id별 로딩상태 표시
    }
}

// MARK: - Action
extension ActivityViewModel {
    enum Action {
        case fetchNewActivities
        case fetchRecommendedActivities
        case fetchAllActivities
        case fetchActivityDetail(id: String)
        case selectCountry(country: Country)
        case selectActivityType(type: ActivityType)
    }
    
    func action(_ action: Action) {
        switch action {
        case .fetchNewActivities:
            input.fetchNewActivities.send(())
        case .fetchRecommendedActivities:
            input.fetchRecommendedActivities.send(())
        case .fetchAllActivities:
            input.fetchAllActivities.send(())
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
            .removeDuplicates { $0 == $1 }
            .sink { [weak self] _ in
                guard let self else { return }
                Task {
                    await self.fetchNewActivities()
                }
            }
            .store(in: &cancellables)
        
        input.fetchRecommendedActivities
            .removeDuplicates { $0 == $1 }
            .sink { [weak self] _ in
                guard let self else { return }
                
                Task {
                    await self.fetchRecommendedActivities()
                }
            }
            .store(in: &cancellables)
        
        input.fetchAllActivities
            .sink { [weak self] _ in
                guard let self else { return }
                Task {
                    await self.fetchActivities(
                        country: self.output.selectedCountry,
                        type: self.output.selectedActivityType
                    )
                }
            }
            .store(in: &cancellables)
        
        input.fetchActivityDetail
            .compactMap { [weak self] id -> String? in
                guard let self = self else { return nil }
                return self.output.activityDetails[id] == nil ? id : nil
            }
            .removeDuplicates()
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
        output.isLoadingNew = true
        defer { output.isLoadingNew = false }
        
        do {
            let response = try await activityRepository.newListLookup(country: nil, category: nil)
            
            output.newActivities = response.data
        } catch {
            print(error)
        }
    }
    
    @MainActor
    private func fetchActivityDetail(id: String) async {
        output.loadingDetails.insert(id)
        defer { output.loadingDetails.remove(id) }
        
        do {
            let response = try await activityRepository.detailLookup(activityId: id)
            
            output.activityDetails[id] = response
        } catch {
            print(error)
        }
    }
    
    @MainActor
    private func fetchRecommendedActivities() async {
        output.isLoadingRecommended = true
        defer { output.isLoadingRecommended = false }
        
        do {
            let response = try await activityRepository.listLookup(country: nil, category: nil, limit: 5, next: nil)
            
            output.recommendedActivities = response.data
        } catch {
            print(error)
        }
    }
    
    // TODO: next(마지막 게시글의 activityId)를 파라미터로 받아서 페이지네이션 처리
    @MainActor
    private func fetchActivities(country: Country?, type: ActivityType?) async {
        output.isLoadingAll = true
        defer { output.isLoadingAll = false }
        
        do {
            let response = try await activityRepository.listLookup(country: country?.title, category: type?.query, limit: nil, next: nil)
            
            output.allActivities = response.data
        } catch {
            print(error)
        }
    }
}
