//
//  ProfileViewModel.swift
//  FLOV
//
//  Created by 조우현 on 5/17/25.
//

import Foundation
import Combine

//final class ProfileViewModel: ViewModelType {
//    private let userRepository: UserRepositoryType
//    private let pathModel: PathModel
//    private let userDefaultsManager: UserDefaultsManager
//    var cancellables: Set<AnyCancellable>
//    var input: Input
//    @Published var output: Output
//    
//    init(
//        userRepository: UserRepositoryType,
//        pathModel: PathModel,
//        userDefaultsManager: UserDefaultsManager,
//        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
//        input: Input = Input(),
//        output: Output = Output()
//    ) {
//        self.userRepository = userRepository
//        self.pathModel = pathModel
//        self.userDefaultsManager = userDefaultsManager
//        self.cancellables = cancellables
//        self.input = input
//        self.output = output
//        transform()
//    }
//    
//    struct Input {
//        let fetchTrigger = PassthroughSubject<Void, Never>()
//    }
//    
//    struct Output {
//        var isLoading = false
//        var showSessionExpiredAlert = false
//        var profile: ProfileLookupResponse?
//        
//        var showErrorAlert = false
//        var errorMessage = ""
//    }
//}
//
//// MARK: - Action
//extension ProfileViewModel {
//    enum Action {
//        case fetchProfile
//    }
//    
//    func action(_ action: Action) {
//        switch action {
//        case .fetchProfile:
//            input.fetchTrigger.send(())
//        }
//    }
//}
//
//// MARK: - Transform
//extension ProfileViewModel {
//    func transform() {
//        setUpFetchProfile()
//    }
//    
//    private func setUpFetchProfile() {
//        input.fetchTrigger
//            .sink { [weak self] _ in
//                guard let self = self else { return }
//                
//                Task {
//                    await self.fetchProfile()
//                }
//            }
//            .store(in: &cancellables)
//    }
//}
//
//// MARK: - Function
//@MainActor
//extension ProfileViewModel {
//    private func fetchProfile() async {
//        output.isLoading = true
//        
//        if !userDefaultsManager.isSigned {
//            pathModel.presentFullScreenCover(.signIn)
//            return
//        }
//        
//        do {
//            let profile = try await userRepository.profileLookup()
//            output.profile = profile
//        } catch NetworkError.refreshTokenExpired {
//            output.showSessionExpiredAlert = true
//        } catch {
//            output.showErrorAlert = true
//            output.errorMessage = error.localizedDescription
//        }
//        output.isLoading = false
//    }
//}
