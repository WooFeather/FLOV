//
//  SignUpViewModel.swift
//  FLOV
//
//  Created by 조우현 on 5/14/25.
//

import Foundation
import Combine

final class SignUpViewModel: ViewModelType {
    private let userRepository: UserRepositoryType
    var cancellables: Set<AnyCancellable>
    
    @Published var input: Input
    @Published var output: Output
    
    private var lastValidatedEmail: String = ""
    
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
        var email: String = ""
        var password: String = ""
        var confirmPassword: String = ""
        var nickname: String = ""
        let emailValidationButtonTapped = PassthroughSubject<Void, Never>()
        let joinButtonTapped = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var isLoading: Bool = false
        var isEmailEdited: Bool = false
        var isPasswordEdited: Bool = false
        var isConfirmPasswordEdited: Bool = false
        var isNicknameEdited: Bool = false
        var isValidEmail: Bool = false
        var isUniqueEmail: Bool = false
        var isEnoughPasswordLength: Bool = false
        var isValidPassword: Bool = false
        var isConfirmPassword: Bool = false
        var isValidNickname: Bool = false
        var loginSuccess: Bool = false
        var showAlert: Bool = false
        var alertMessage: String = ""
    }
}

// MARK: - Action
extension SignUpViewModel {
    enum Action {
        case validateEmail
        case join
    }
    
    func action(_ action: Action) {
        switch action {
        case .validateEmail:
            input.emailValidationButtonTapped.send(())
        case .join:
            input.joinButtonTapped.send(())
        }
    }
}

// MARK: - Transform
extension SignUpViewModel {
    func transform() {
        // 이메일 입력 감지 및 유효성 검사
        $input
            .map(\.email)
            .sink { [weak self] email in
                guard let self else { return }
                output.isEmailEdited = !email.isEmpty
                output.isValidEmail = isValidEmail(email)
                // 입력이 바뀌면 중복 확인 상태 초기화
                if email != lastValidatedEmail {
                    output.isUniqueEmail = false
                }
            }
            .store(in: &cancellables)
        
        // 비밀번호 입력 감지 및 유효성 검사
        $input
            .map(\.password)
            .sink { [weak self] password in
                guard let self else { return }
                output.isPasswordEdited = !password.isEmpty
                output.isEnoughPasswordLength = password.count >= 8
                output.isValidPassword = isValidPassword(password)
            }
            .store(in: &cancellables)
        
        // 비밀번호 확인 입력 감지
        $input
            .combineLatest($input.map(\.password), $input.map(\.confirmPassword))
            .sink { [weak self] (_, password, confirmPassword) in
                guard let self else { return }
                output.isConfirmPasswordEdited = !confirmPassword.isEmpty
                output.isConfirmPassword = password == confirmPassword && !password.isEmpty
            }
            .store(in: &cancellables)
        
        // 닉네임 입력 감지 및 유효성 검사
        $input
            .map(\.nickname)
            .sink { [weak self] nickname in
                guard let self else { return }
                output.isNicknameEdited = !nickname.isEmpty
                output.isValidNickname = isValidNickname(nickname)
            }
            .store(in: &cancellables)
        
        input.emailValidationButtonTapped
            .sink { [weak self] _ in
                guard let self else { return }
                Task {
                    await self.handleLogin {
                        try await self.validateEmail()
                    }
                }
            }
            .store(in: &cancellables)
        
        input.joinButtonTapped
            .sink { [weak self] _ in
                guard let self else { return }
                guard output.isValidEmail,
                      output.isUniqueEmail,
                      output.isValidPassword,
                      output.isEnoughPasswordLength,
                      output.isConfirmPassword,
                      output.isValidNickname else {
                    output.showAlert = true
                    output.alertMessage = "모든 필드를 올바르게 입력해주세요."
                    return
                }
                
                Task {
                    await self.handleLogin {
                        try await self.join()
                    }
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Functions
extension SignUpViewModel {
    @MainActor
    private func validateEmail() async throws {
        let _: EmailValidateResponse = try await userRepository.emailValidate(
            request: .init(email: input.email)
        )
        
        lastValidatedEmail = input.email
        output.isUniqueEmail = true
    }
    
    @MainActor
    private func join() async throws {
        _ = try await userRepository.join(
            request: .init(
                email : input.email,
                password : input.password,
                nick : input.nickname,
                phoneNum : nil,
                introduction: nil,
                deviceToken : nil
            )
        )
        
        _ = try await userRepository.login(
            request: .init(
                email : input.email,
                password : input.password,
                deviceToken: nil
            )
        )
        
        output.loginSuccess = true
    }
    
    @MainActor
    private func handleLogin(action: @escaping () async throws -> Void) async {
        output.isLoading = true
        do {
            try await action()
        } catch {
            output.showAlert = true
            output.alertMessage = error.localizedDescription
        }
        output.isLoading = false
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", pattern)
            .evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let pattern = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern)
            .evaluate(with: password)
    }
    
    private func isValidNickname(_ nickname: String) -> Bool {
        let pattern = "[.,?*_@]"
        return !NSPredicate(format: "SELF MATCHES %@", pattern)
            .evaluate(with: nickname)
    }
}
