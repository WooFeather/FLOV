//
//  SignInViewModel.swift
//  FLOV
//
//  Created by 조우현 on 5/13/25.
//

import Foundation
import AuthenticationServices
import Combine
import KakaoSDKAuth
import KakaoSDKUser

final class SignInViewModel: ViewModelType {
    private let userRepository: UserRepositoryType
    var cancellables: Set<AnyCancellable>
    var input: Input
    @Published var output: Output
    
    init(
        userRepository: UserRepositoryType,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        input: Input = Input(),
        output: Output = Output()
    ) {
        self.userRepository = userRepository
        self.cancellables = cancellables
        self.input = input
        self.output = output
        transform()
    }
    
    struct Input {
        let kakaoLoginButtonTapped = PassthroughSubject<Void, Never>()
        let appleLoginButtonTapped = PassthroughSubject<Result<ASAuthorization, Error>, Never>()
        let emailLoginButtonTapped = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var isLoading = false
        var loginSuccess = false
        var showAlert = false
        var alertMessage = ""
    }
}

// MARK: - Action
extension SignInViewModel {
    enum Action {
        case kakaoLogin
        case appleLogin(result: Result<ASAuthorization, Error>)
    }
    
    func action(_ action: Action) {
        switch action {
        case .kakaoLogin:
            input.kakaoLoginButtonTapped.send(())
        case .appleLogin(let result):
            input.appleLoginButtonTapped.send(result)
        }
    }
}

// MARK: - Transform
extension SignInViewModel {
    func transform() {
        setupKakaoLogin()
        setupAppleLogin()
    }
    
    private func setupKakaoLogin() {
        input.kakaoLoginButtonTapped
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                Task {
                    await self.handleLogin {
                        try await self.kakaoLogin()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupAppleLogin() {
        input.appleLoginButtonTapped
            .sink { [weak self] result in
                guard let self = self else { return }
                
                Task {
                    await self.handleLogin {
                        try await self.appleLogin(result: result)
                    }
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Function
@MainActor
extension SignInViewModel {
    private func kakaoLogin() async throws {
        let oauth = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<OAuthToken, Error>) in
            let callback: (OAuthToken?, Error?) -> Void = { token, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let token {
                    continuation.resume(returning: token)
                }
            }
            
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk(completion: callback)
            } else {
                UserApi.shared.loginWithKakaoAccount(completion: callback)
            }
        }
        
        let deviceToken = try await TokenManager.shared.fetchFCMToken()
        
        _ = try await userRepository.kakaoLogin(
            request: .init(oauthToken: oauth.accessToken, deviceToken: deviceToken)
        )
    }
    
    private func appleLogin(result: Result<ASAuthorization, Error>) async throws {
        switch result {
        case .success(let auth):
            guard let appleID = auth.credential as? ASAuthorizationAppleIDCredential,
                  let identityData = appleID.identityToken,
                  let idToken = String(data: identityData, encoding: .utf8)
            else {
                print("애플 로그인 credential 파싱 실패")
                return
            }
            
            let name = [appleID.fullName?.familyName, appleID.fullName?.givenName]
                .compactMap { $0 }
                .joined()
            
            let deviceToken = try await TokenManager.shared.fetchFCMToken()
            
            _ = try await userRepository.appleLogin(
                request: .init(idToken: idToken, deviceToken: deviceToken, nick: name)
            )
            
        case .failure(let error):
            throw error
        }
    }
    
    private func handleLogin(action: () async throws -> Void) async {
        output.isLoading = true
        do {
            try await action()
            output.loginSuccess = true
        } catch {
            output.showAlert = true
            output.alertMessage = error.localizedDescription
        }
        output.isLoading = false
    }
}
