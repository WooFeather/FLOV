//
//  PostViewModel.swift
//  FLOV
//
//  Created by 조우현 on 6/21/25.
//

import Foundation
import Combine
import CoreLocation

final class PostViewModel: ViewModelType {
    private let postRepository: PostRepositoryType
    private let locationService: LocationServiceType
    private let postId: String
    var cancellables: Set<AnyCancellable>
    var input: Input
    
    @Published var output: Output
    
    init(
        postRepository: PostRepositoryType,
        locationService: LocationServiceType,
        postId: String,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        input: Input = Input(),
        output: Output = Output()
    ) {
        self.postRepository = postRepository
        self.locationService = locationService
        self.postId = postId
        self.cancellables = cancellables
        self.input = input
        self.output = output
        transform()
    }
    
    struct Input {
        let fetchPosts = PassthroughSubject<Void, Never>()
        let refreshPosts = PassthroughSubject<Void, Never>()
        let setDistance = PassthroughSubject<Int, Never>()
    }
    
    struct Output {
        var ads: [AdBannerEntity] = MockDataBuilder.ads
        var posts: [PostEntity] = []
        var isLoading: Bool = false
        var errorMessage: String?
        var infoMessage: String = ""
        var selectedDistance: Int = 10000 // 기본값 10km
    }
}

// MARK: - Action
extension PostViewModel {
    enum Action {
        case fetchPosts
        case refreshPosts
        case setDistance(Int)
    }
    
    func action(_ action: Action) {
        switch action {
        case .fetchPosts:
            input.fetchPosts.send(())
        case .refreshPosts:
            input.refreshPosts.send(())
        case .setDistance(let distance):
            input.setDistance.send(distance)
        }
    }
}

// MARK: - Transform
extension PostViewModel {
    func transform() {
        locationService.infoPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] msg in
                self?.output.infoMessage = msg
            }
            .store(in: &cancellables)
        
        locationService.authorizationStatus
            .filter { $0 == .authorizedWhenInUse || $0 == .authorizedAlways }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.output.infoMessage = ""
            }
            .store(in: &cancellables)
        
        let initialFetch = input.fetchPosts.prefix(1)
        let refreshFetch = input.refreshPosts
        
        let fetchStream = initialFetch
            .merge(with: refreshFetch)
            .handleEvents(receiveOutput: { [weak self] in
                DispatchQueue.main.async {
                    self?.output.isLoading = true
                }
                
                self?.locationService.requestLocationPermission()
            })
        
        fetchStream
            .flatMap { [weak self] _ -> AnyPublisher<CLLocation, Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                if let cached = self.locationService.lastKnownLocation {
                    return Just(cached).eraseToAnyPublisher()
                }
                return self.locationService.currentLocation
                    .compactMap { $0 }
                    .prefix(1)
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                Task {
                    await self?.fetchPostsWithLocation(
                        location,
                        maxDistance: String(self?.output.selectedDistance ?? 1000),
                        next: nil,
                        orderBy: .createdAt
                    )
                }
            }
            .store(in: &cancellables)
        
        input.setDistance
            .receive(on: DispatchQueue.main)
            .sink { [weak self] distance in
                self?.output.selectedDistance = distance
                
                if let location = self?.locationService.lastKnownLocation {
                    self?.output.isLoading = true
                    Task {
                        await self?.fetchPostsWithLocation(
                            location,
                            maxDistance: String(distance),
                            next: nil,
                            orderBy: .createdAt
                        )
                    }
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Functions
private extension PostViewModel {
    @MainActor
    private func fetchPostsWithLocation(_ location: CLLocation, maxDistance: String? ,next: String?, orderBy: OrderBy) async {
        output.errorMessage = nil
        
        do {
            let response = try await postRepository.postLookup(
                country: nil,
                category: nil,
                longitude: location.coordinate.longitude,
                latitude: location.coordinate.latitude,
                maxDistance: maxDistance,
                limit: nil,
                next: next,
                orderBy: orderBy.rawValue
            )
            output.posts = response.data
        } catch {
            output.errorMessage = "게시글을 불러오는데 실패했습니다."
            print("Error fetching posts: \(error)")
        }
        
        output.isLoading = false
    }
}

// MARK: - Helper
private extension PostViewModel {
    enum OrderBy: String {
        case createdAt
        case likes
    }
}
