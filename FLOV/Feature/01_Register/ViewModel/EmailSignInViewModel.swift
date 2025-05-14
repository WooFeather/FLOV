//
//  EmailSignInView.swift
//  FLOV
//
//  Created by 조우현 on 5/14/25.
//

import Foundation
import Combine

final class EmailSignInViewModel: ViewModelType {
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
        var email = ""
        var password = ""
        let loginButtonTapped = PassthroughSubject<Void, Never>()
        let signUpButtonTaped = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let isLoading = CurrentValueSubject<Bool, Never>(false)
        let loginSuccess = PassthroughSubject<Void, Never>()
        let alertMessage = PassthroughSubject<String, Never>()
    }
}

// MARK: - Action
extension EmailSignInViewModel {
    enum Action {
        case login
        case signUp
    }
    
    func action(_ action: Action) {
        switch action {
        case .login:
            input.loginButtonTapped.send(())
        case .signUp:
            input.signUpButtonTaped.send(())
        }
    }
}

// MARK: - Transform
extension EmailSignInViewModel {
    func transform() {
        setupEmailLogin()
        setupSignup()
    }
    
    private func setupEmailLogin() {
        input.loginButtonTapped
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                Task {
                    await self.handleLogin {
                        try await self.emailLogin()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupSignup() {
        input.signUpButtonTaped
            .sink {
                // TODO: 화면전환을 위한 트리깅
                print("SignUpView 화면전환")
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    private func handleLogin(action: () async throws -> Void) async {
        output.isLoading.send(true)
        do {
            try await action()
            output.loginSuccess.send(())
        } catch let userError as UserRepository.UserError {
            switch userError {
            case .server(let message):
                output.alertMessage.send(message)
            default:
                output.alertMessage.send(userError.localizedDescription)
            }
        }
        catch {
            output.alertMessage.send(error.localizedDescription)
        }
        output.isLoading.send(false)
    }
}

// MARK: - Functions
extension EmailSignInViewModel {
    func emailLogin() async throws {
        let response = try await userRepository.login(request: .init(email: input.email, password: input.password, deviceToken: nil))
        
        dump(response)
    }
}
