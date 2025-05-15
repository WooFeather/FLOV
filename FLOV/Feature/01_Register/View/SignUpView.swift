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
                if viewModel.output.isEmailEdited {
                    if !viewModel.output.isValidEmail {
                        Text("올바른 이메일 형식이 아닙니다.")
                            .font(.Body.body3)
                            .foregroundStyle(.colRosy)
                    } else if viewModel.output.isUniqueEmail {
                        Text("사용 가능한 이메일 입니다.")
                            .font(.Body.body3)
                            .foregroundStyle(.colDeep)
                    } else {
                        Text("이메일 중복확인을 해주세요.")
                            .font(.Body.body3)
                            .foregroundStyle(.gray90)
                    }
                }
                
                Spacer()
                
                UnderlineTextButton("이메일 중복확인") {
                    viewModel.action(.validateEmail)
                }
                .disabled(!viewModel.output.isValidEmail || viewModel.output.isUniqueEmail)
            }
        }
    }
}

// MARK: - PasswordFieldView
extension SignUpView {
    func passwordFieldView() -> some View {
        VStack {
            RoundedTextField(fieldTitle: "비밀번호", text: $viewModel.input.password, isSecureField: true)
            
            if !viewModel.input.password.isEmpty {
                HStack {
                    if viewModel.output.isPasswordEdited {
                        if !viewModel.output.isEnoughPasswordLength {
                            Text("비밀번호는 8자 이상이어야 합니다.")
                                .font(.Body.body3)
                                .foregroundStyle(.colRosy)
                        } else if !viewModel.output.isValidPassword {
                            Text("영문, 숫자, 특수문자를 각 1개 이상 포함해야 합니다.")
                                .font(.Body.body3)
                                .foregroundStyle(.colRosy)
                        } else {
                            Text("사용 가능한 비밀번호 입니다.")
                                .font(.Body.body3)
                                .foregroundStyle(.colDeep)
                        }
                        
                        Spacer()
                    }
                }
            }
        }
    }

    func validatePasswordFieldView() -> some View {
        VStack {
            RoundedTextField(fieldTitle: "비밀번호 확인", text: $viewModel.input.confirmPassword, isSecureField: true)
            
            if !viewModel.input.confirmPassword.isEmpty {
                HStack {
                    if viewModel.output.isConfirmPasswordEdited {
                        if viewModel.output.isConfirmPassword {
                            Text("비밀번호가 일치합니다.")
                                .font(.Body.body3)
                                .foregroundStyle(.colDeep)
                        } else {
                            Text("비밀번호가 일치하지 않습니다.")
                                .font(.Body.body3)
                                .foregroundStyle(.colRosy)
                        }
                        
                        Spacer()
                    }
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
            
            if !viewModel.input.nickname.isEmpty {
                HStack {
                    if viewModel.output.isNicknameEdited {
                        if viewModel.output.isValidNickname {
                            Text("사용 가능한 닉네임 입니다.")
                                .font(.Body.body3)
                                .foregroundStyle(.colDeep)
                        } else {
                            Text(". , ? * _ @ 는 닉네임으로 사용할 수 없습니다.")
                                .font(.Body.body3)
                                .foregroundStyle(.colRosy)
                        }
                        
                        Spacer()
                    }
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
        .disabled(
            !viewModel.output.isValidEmail ||
            !viewModel.output.isUniqueEmail ||
            !viewModel.output.isEnoughPasswordLength ||
            !viewModel.output.isValidPassword ||
            !viewModel.output.isConfirmPassword ||
            !viewModel.output.isValidNickname
        )
    }
}

#if DEBUG
#Preview {
    SignUpView(viewModel: SignUpViewModel(userRepository: UserRepository.shared))
}
#endif
