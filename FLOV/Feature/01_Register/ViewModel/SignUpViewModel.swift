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
        var confirmPassword = ""
        var nickname = ""
        let emailValidationButtonTapped = PassthroughSubject<Void, Never>()
        let joinButtonTapped = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let isLoading = CurrentValueSubject<Bool, Never>(false)
        
        // TODO: 텍스트필드에 입력을 시작했을때 상태변경
        let isValidEmail = CurrentValueSubject<Bool, Never>(false)
        let isUniqueEmail = CurrentValueSubject<Bool, Never>(false)
        let isEnoughPasswordLength = CurrentValueSubject<Bool, Never>(false)
        let isValidPassword = CurrentValueSubject<Bool, Never>(false)
        let isConfirmPassword = CurrentValueSubject<Bool, Never>(false)
        let isValidNickname = CurrentValueSubject<Bool, Never>(false)
        
        let loginSuccess = PassthroughSubject<Void, Never>()
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
        // TODO: join버튼을 누르면 로그인까지 진행
    }
}

// MARK: - Functions
extension SignUpViewModel {
    private func validateEmail() async throws {
        let response = try await userRepository.emailValidate(request: .init(email: input.email))
        dump(response)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", pattern)
            .evaluate(with: email)
    }
}
