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
        let isLoading = CurrentValueSubject<Bool, Never>(false)
        let loginSuccess = PassthroughSubject<Void, Never>()
        let alertMessage = PassthroughSubject<String, Never>()
    }
}

// MARK: - Action
extension SignInViewModel {
    enum Action {
        case kakaoLogin
        case appleLogin(result: Result<ASAuthorization, Error>)
        case emailLogin
    }
    
    func action(_ action: Action) {
        switch action {
        case .kakaoLogin:
            input.kakaoLoginButtonTapped.send(())
        case .appleLogin(let result):
            input.appleLoginButtonTapped.send(result)
        case .emailLogin:
            input.emailLoginButtonTapped.send(())
        }
    }
}

// MARK: - Transform
extension SignInViewModel {
    func transform() {
        input.kakaoLoginButtonTapped
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                Task {
                    await MainActor.run { self.output.isLoading.send(true) }
                    
                    do {
                        try await self.kakaoLogin()
                        await MainActor.run { self.output.loginSuccess.send(()) }
                    } catch {
                        let msg: String
                        if case let NetworkError.apiError(message) = error {
                            msg = message
                        } else {
                            msg = error.localizedDescription
                        }
                        await MainActor.run { self.output.alertMessage.send(msg) }
                    }
                    
                    await MainActor.run { self.output.isLoading.send(false) }
                }
            }
            .store(in: &cancellables)
        
        input.appleLoginButtonTapped
            .sink { [weak self] result in
                guard let self = self else { return }
                Task {
                    await MainActor.run { self.output.isLoading.send(true) }
                    
                    do {
                        try await self.appleLogin(result: result)
                        
                        await MainActor.run { self.output.loginSuccess.send(()) }
                    } catch {
                        let msg: String
                        if case let NetworkError.apiError(message) = error {
                            msg = message
                        } else {
                            msg = error.localizedDescription
                        }
                        await MainActor.run { self.output.alertMessage.send(msg) }
                    }
                    
                    await MainActor.run { self.output.isLoading.send(false) }
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Function
@MainActor
extension SignInViewModel {
    func kakaoLogin() async throws {
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
        
        let response = try await userRepository.kakaoLogin(
            request: .init(oauthToken: oauth.accessToken, deviceToken: nil)
        )
        
        // TODO: NetworkLog라는 디버깅용 객체 만들어서 대응
        dump(response)
    }
    
    func appleLogin(result: Result<ASAuthorization, Error>) async throws {
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
            
            do {
                let response = try await userRepository.appleLogin(
                    request: .init(idToken: idToken, deviceToken: nil, nick: name)
                )
                print("애플 로그인 성공:", response)
            } catch {
                print("애플 로그인 실패:", error)
            }
            
        case .failure(let error):
            print("Apple 로그인 에러:", error.localizedDescription)
        }
    }
}
