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
        // 뷰가 나타났을 때 위치 기반 게시글 조회
        input.fetchPosts
            .prefix(1)
            .sink { [weak self] in
                guard let self else { return }
                self.fetchPosts()
            }
            .store(in: &cancellables)
        
        // 새로고침
        input.refreshPosts
            .sink { [weak self] in
                guard let self else { return }
                self.fetchPosts()
            }
            .store(in: &cancellables)
        
        locationService.infoPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] msg in
                self?.output.infoMessage = msg
            }
            .store(in: &cancellables)
        
        locationService.authorizationStatus
            .filter { status in
                status == .authorizedWhenInUse || status == .authorizedAlways
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.output.infoMessage = ""
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Functions
private extension PostViewModel {
    func fetchPosts() {
        // 위치 서비스 요청
        self.locationService.requestLocationPermission()
        // 마지막으로 알려진 위치가 있다면 바로 게시글 조회
        if let lastLocation = locationService.lastKnownLocation {
            Task {
                await fetchPostsWithLocation(lastLocation)
            }
        }
    }
    
    @MainActor
    func fetchPostsWithLocation(_ location: CLLocation) async {
        output.isLoading = true
        output.errorMessage = nil
        
        do {
            let response = try await postRepository.postLookup(
                country: nil,
                category: nil,
                longitude: location.coordinate.longitude,
                latitude: location.coordinate.latitude,
                maxDistance: "100000000", // 100000km
                limit: nil,
                next: nil,
                orderBy: "createdAt" // 최신순
            )
            
            output.posts = response.data
            output.isLoading = false
        } catch {
            output.errorMessage = "게시글을 불러오는데 실패했습니다."
            output.isLoading = false
            print("Error fetching posts: \(error)")
        }
    }
}
