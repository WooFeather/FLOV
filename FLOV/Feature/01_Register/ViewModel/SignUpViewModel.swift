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
        var loginSuccess: Bool = false
        var showAlert: Bool = false
        var alertMessage: String = ""
        
        var isJoinButtonEnabled: Bool = false
        var isEmailValidationButtonEnabled: Bool = false
        
        var emailStatusMessage: FieldStatus = .none
        var passwordStatusMessage: FieldStatus = .none
        var confirmPasswordStatusMessage: FieldStatus = .none
        var nicknameStatusMessage: FieldStatus = .none
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
        $input
            .map(\.email)
            .sink { [weak self] email in
                guard let self else { return }
                self.updateEmailStatus(email)
                
                let isValidEmailFormat = self.isValidEmail(email)
                self.output.isEmailValidationButtonEnabled = isValidEmailFormat && email != self.lastValidatedEmail
            }
            .store(in: &cancellables)
        
        $input
            .map(\.password)
            .sink { [weak self] password in
                guard let self else { return }
                self.updatePasswordStatus(password)
            }
            .store(in: &cancellables)
        
        $input
            .combineLatest($input.map(\.password), $input.map(\.confirmPassword))
            .sink { [weak self] (_, password, confirmPassword) in
                guard let self else { return }
                self.updateConfirmPasswordStatus(password, confirmPassword)
            }
            .store(in: &cancellables)
        
        $input
            .map(\.nickname)
            .sink { [weak self] nickname in
                guard let self else { return }
                self.updateNicknameStatus(nickname)
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
                guard self.output.isJoinButtonEnabled else {
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
        updateEmailStatus(input.email)
        
        output.isEmailValidationButtonEnabled = false
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

// MARK: - State
extension SignUpViewModel {
    enum FieldStatus {
        case none
        case valid(String)
        case invalid(String)
        case pending(String)
        
        var message: String {
            switch self {
            case .none:
                return ""
            case .valid(let message), .invalid(let message), .pending(let message):
                return message
            }
        }
        
        var isValid: Bool {
            if case .valid = self {
                return true
            }
            return false
        }
    }
    
    private func updateEmailStatus(_ email: String) {
        if email.isEmpty {
            output.emailStatusMessage = .none
            return
        }
        
        let isValid = isValidEmail(email)
        if !isValid {
            output.emailStatusMessage = .invalid("올바른 이메일 형식이 아닙니다.")
            return
        }
        
        if email == lastValidatedEmail {
            output.emailStatusMessage = .valid("사용 가능한 이메일 입니다.")
        } else {
            output.emailStatusMessage = .pending("이메일 중복확인을 해주세요.")
        }
        
        updateJoinButtonEnabled()
    }
    
    private func updatePasswordStatus(_ password: String) {
        if password.isEmpty {
            output.passwordStatusMessage = .none
            return
        }
        
        if password.count < 8 {
            output.passwordStatusMessage = .invalid("비밀번호는 8자 이상이어야 합니다.")
            return
        }
        
        if !isValidPassword(password) {
            output.passwordStatusMessage = .invalid("영문, 숫자, 특수문자를 각 1개 이상 포함해야 합니다.")
            return
        }
        
        output.passwordStatusMessage = .valid("사용 가능한 비밀번호 입니다.")
        
        updateConfirmPasswordStatus(password, input.confirmPassword)
        updateJoinButtonEnabled()
    }
    
    private func updateConfirmPasswordStatus(_ password: String, _ confirmPassword: String) {
        if confirmPassword.isEmpty {
            output.confirmPasswordStatusMessage = .none
            return
        }
        
        if password == confirmPassword {
            output.confirmPasswordStatusMessage = .valid("비밀번호가 일치합니다.")
        } else {
            output.confirmPasswordStatusMessage = .invalid("비밀번호가 일치하지 않습니다.")
        }
        updateJoinButtonEnabled()
    }
    
    private func updateNicknameStatus(_ nickname: String) {
        if nickname.isEmpty {
            output.nicknameStatusMessage = .none
            return
        }
        
        if isValidNickname(nickname) {
            output.nicknameStatusMessage = .valid("사용 가능한 닉네임 입니다.")
        } else {
            output.nicknameStatusMessage = .invalid(". , ? * _ @ 는 닉네임으로 사용할 수 없습니다.")
        }
        updateJoinButtonEnabled()
    }
    
    private func updateJoinButtonEnabled() {
        output.isJoinButtonEnabled =
        output.emailStatusMessage.isValid &&
        output.passwordStatusMessage.isValid &&
        output.confirmPasswordStatusMessage.isValid &&
        output.nicknameStatusMessage.isValid &&
        (lastValidatedEmail == input.email)
    }
}
