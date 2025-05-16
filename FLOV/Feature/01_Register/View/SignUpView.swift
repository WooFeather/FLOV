//
//  SignUpView.swift
//  FLOV
//
//  Created by 조우현 on 5/13/25.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var viewModel: SignUpViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                inputFieldView()
                joinButtonView()
            }
            // viewModel.output.loginSuccess가 true일때 화면전환
            .onChange(of: viewModel.output.loginSuccess) { success in
                if success {
                    // TODO: PathModel 적용하여 화면 전환
                }
            }
            .padding()
            .asNavigationToolbar()
            .alert(viewModel.output.alertMessage, isPresented: $viewModel.output.showAlert) {
                Button("확인", role: .cancel) { }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // TODO: PathModel 적용
                    } label: {
                        Image(.icnChevron)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Sign Up")
                        .foregroundStyle(.colDeep)
                        .font(.Caption.caption0)
                }
            }
        }
    }
}

// MARK: - InputField
extension SignUpView {
    func inputFieldView() -> some View {
        ScrollView {
            VStack(spacing: 18) {
                emailFieldView()
                passwordFieldView()
                validatePasswordFieldView()
                nicknameFieldView()
            }
        }
    }
}

// MARK: - EmailField
extension SignUpView {
    func emailFieldView() -> some View {
        VStack {
            RoundedTextField(fieldTitle: "이메일", text: $viewModel.input.email)

            HStack {
                if !viewModel.output.emailStatusMessage.message.isEmpty {
                    Text(viewModel.output.emailStatusMessage.message)
                        .font(.Body.body3)
                        .foregroundStyle(viewModel.output.emailStatusMessage.isValid ? .colDeep : .colRosy)
                }
                
                Spacer()
                
                UnderlineTextButton("이메일 중복확인") {
                    viewModel.action(.validateEmail)
                }
                .disabled(!viewModel.output.isEmailValidationButtonEnabled)
            }
        }
    }
}

// MARK: - PasswordFieldView
extension SignUpView {
    func passwordFieldView() -> some View {
        VStack {
            RoundedTextField(fieldTitle: "비밀번호", text: $viewModel.input.password, isSecureField: true)
            
            if !viewModel.output.passwordStatusMessage.message.isEmpty {
                HStack {
                    Text(viewModel.output.passwordStatusMessage.message)
                        .font(.Body.body3)
                        .foregroundStyle(viewModel.output.passwordStatusMessage.isValid ? .colDeep : .colRosy)
                    
                    Spacer()
                }
            }
        }
    }

    func validatePasswordFieldView() -> some View {
        VStack {
            RoundedTextField(fieldTitle: "비밀번호 확인", text: $viewModel.input.confirmPassword, isSecureField: true)
            
            if !viewModel.output.confirmPasswordStatusMessage.message.isEmpty {
                HStack {
                    Text(viewModel.output.confirmPasswordStatusMessage.message)
                        .font(.Body.body3)
                        .foregroundStyle(viewModel.output.confirmPasswordStatusMessage.isValid ? .colDeep : .colRosy)
                    
                    Spacer()
                }
            }
        }
    }
}

// MARK: - NicknameFieldView
extension SignUpView {
    func nicknameFieldView() -> some View {
        VStack {
            RoundedTextField(fieldTitle: "닉네임", text: $viewModel.input.nickname)
            
            if !viewModel.output.nicknameStatusMessage.message.isEmpty {
                HStack {
                    Text(viewModel.output.nicknameStatusMessage.message)
                        .font(.Body.body3)
                        .foregroundStyle(viewModel.output.nicknameStatusMessage.isValid ? .colDeep : .colRosy)
                    
                    Spacer()
                }
            }
        }
        .padding(.bottom, 12)
    }
}

// MARK: - JoinButton
extension SignUpView {
    func joinButtonView() -> some View {
        ActionButton(text: "가입하기") {
            viewModel.action(.join)
        }
        .disabled(!viewModel.output.isJoinButtonEnabled)
    }
}


#if DEBUG
#Preview {
    SignUpView(viewModel: SignUpViewModel(userRepository: UserRepository.shared))
}
#endif
