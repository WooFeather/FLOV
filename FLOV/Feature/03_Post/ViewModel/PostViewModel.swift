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
        let fetchPosts = PassthroughSubject<Void, Never>()
        let refreshPosts = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var ads: [AdBannerEntity] = MockDataBuilder.ads
        var posts: [PostEntity] = []
        var isLoading: Bool = false
        var errorMessage: String?
        var infoMessage: String = ""
    }
}

// MARK: - Action
extension PostViewModel {
    enum Action {
        case fetchPosts
        case refreshPosts
    }
    
    func action(_ action: Action) {
        switch action {
        case .fetchPosts:
            input.fetchPosts.send(())
        case .refreshPosts:
            input.refreshPosts.send(())
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
            .handleEvents(
                receiveOutput: { [weak self] in
                    self?.locationService.requestLocationPermission()
                }
            )
        
        fetchStream
            .flatMap { [weak self] _ -> AnyPublisher<CLLocation, Never> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                return self.locationService.currentLocation
                    .compactMap { $0 }
                    .prefix(1)
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                Task { await self?.fetchPostsWithLocation(location) }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Functions
private extension PostViewModel {
    @MainActor
    private func fetchPostsWithLocation(_ location: CLLocation) async {
        output.isLoading = true
        output.errorMessage = nil
        
        do {
            let response = try await postRepository.postLookup(
                country: nil,
                category: nil,
                longitude: location.coordinate.longitude,
                latitude: location.coordinate.latitude,
                maxDistance: "100000000",
                limit: nil,
                next: nil,
                orderBy: "createdAt"
            )
            output.posts = response.data
        } catch {
            output.errorMessage = "게시글을 불러오는데 실패했습니다."
            print("Error fetching posts: \(error)")
        }
        
        output.isLoading = false
    }
}
