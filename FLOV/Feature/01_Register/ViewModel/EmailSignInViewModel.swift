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
    @Published var showAlert = false
    @Published var alertMessage = ""
    
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
                
                if !isValidEmail(input.email) {
                    showAlert = true
                    alertMessage = "올바른 이메일 형식이 아닙니다."
                    return
                }
                
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
}

// MARK: - Functions
extension EmailSignInViewModel {
    private func emailLogin() async throws {
        let response = try await userRepository.login(request: .init(email: input.email, password: input.password, deviceToken: nil))
        
        dump(response)
    }
    
    @MainActor
    private func handleLogin(action: () async throws -> Void) async {
        output.isLoading.send(true)
        do {
            try await action()
            output.loginSuccess.send(())
        } catch {
            showAlert = true
            alertMessage = error.localizedDescription
        }
        output.isLoading.send(false)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", pattern)
            .evaluate(with: email)
    }
}
