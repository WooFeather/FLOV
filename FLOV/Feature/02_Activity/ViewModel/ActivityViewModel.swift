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
    
    private var rawAllActivities: [ActivitySummaryEntity] = []
    
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
        let fetchMoreActivities = PassthroughSubject<Void, Never>()
        let fetchActivityDetail = PassthroughSubject<String, Never>()
        
        let didSelectCountry = PassthroughSubject<Country, Never>()
        let didSelectActivityType = PassthroughSubject<ActivityType, Never>()
        
        let activityId = PassthroughSubject<String, Never>()
        let keepToggle = PassthroughSubject<Bool, Never>()
    }
    
    struct Output {
        var newActivities: [ActivitySummaryEntity] = []
        var recommendedActivities: [ActivitySummaryEntity] = []
        var allActivities: [ActivitySummaryEntity] = []
        var activityDetails: [String: ActivityDetailEntity] = [:]
        var ads: [AdBannerEntity] = MockDataBuilder.ads
        
        var nextCursor: String? = nil
        var isLodingMore = false
        
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
        case fetchMoreActivities
        case fetchActivityDetail(id: String)
        case selectCountry(country: Country)
        case selectActivityType(type: ActivityType)
        case keepToggle(id: String, keepStatus: Bool)
    }
    
    func action(_ action: Action) {
        switch action {
        case .fetchNewActivities:
            input.fetchNewActivities.send(())
        case .fetchRecommendedActivities:
            input.fetchRecommendedActivities.send(())
        case .fetchAllActivities:
            input.fetchAllActivities.send(())
        case .fetchMoreActivities:
            input.fetchMoreActivities.send(())
        case .fetchActivityDetail(id: let id):
            input.fetchActivityDetail.send(id)
        case .selectCountry(let country):
            input.didSelectCountry.send(country)
        case .selectActivityType(let type):
            input.didSelectActivityType.send(type)
        case .keepToggle(let id, keepStatus: let keepStatus):
            input.activityId.send(id)
            input.keepToggle.send(keepStatus)
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
                
                action(.fetchAllActivities)
            }
            .store(in: &cancellables)
        
        input.fetchAllActivities
            .sink { [weak self] _ in
                guard let self else { return }
                // 초기 로드 및 필터 변경 시 커서 초기화
                output.nextCursor = nil
                
                Task {
                    await self.fetchActivities(
                        country: self.output.selectedCountry,
                        type: self.output.selectedActivityType,
                        next: nil
                    )
                }
            }
            .store(in: &cancellables)
        
        input.fetchMoreActivities
            .sink { [weak self] _ in
                guard let self = self,
                      let cursor = output.nextCursor else { return }
                
                Task {
                    await self.fetchActivities(
                        country: self.output.selectedCountry,
                        type: self.output.selectedActivityType,
                        next: cursor
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
        
        input.activityId
            .zip(input.keepToggle)
            .sink { [weak self] id, status in
                guard let self = self else { return }
                Task {
                    await self.keepToggle(id: id, keepStatus: status)
                }
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
            let response = try await activityRepository
                .listLookup(country: nil, category: nil, limit: nil, next: nil)

            // 추천 리스트 갱신
            output.recommendedActivities = response.data

            // 전체 리스트 재필터링
            filterActivities()

        } catch {
            print(error)
        }
    }
    
    @MainActor
    private func fetchActivities(country: Country?, type: ActivityType?, next: String?) async {
        if next == nil {
            output.isLoadingAll = true
        } else {
            output.isLodingMore = true
        }
        
        defer {
            if next == nil {
                output.isLoadingAll = false
            } else {
                output.isLodingMore = false
            }
        }

        do {
            let response = try await activityRepository
                .listLookup(
                    country: country?.title,
                    category: type?.query,
                    limit: 10,
                    next: next
                )
            
            output.nextCursor = response.nextCursor

            if next == nil {
                rawAllActivities = response.data
            } else {
                rawAllActivities += response.data
            }

            filterActivities()
        } catch {
            print(error)
        }
    }
    
    @MainActor
    private func keepToggle(id: String, keepStatus: Bool) async {
        do {
            _ = try await activityRepository.keep(activityId: id, request: .init(keepStatus: keepStatus))
        } catch {
            print(error)
        }
    }
    
    private func filterActivities() {
        let recommendedIDs = Set(output.recommendedActivities.map { $0.id })
        output.allActivities = rawAllActivities
            .filter { !recommendedIDs.contains($0.id) }
    }
}
