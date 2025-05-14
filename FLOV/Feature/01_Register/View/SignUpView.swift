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
            .padding(.horizontal)
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
                if !viewModel.output.isValidEmail.value {
                    Text("올바른 이메일 형식이 아닙니다.")
                        .font(.Body.body3)
                        .foregroundStyle(.colRosy)
                } else if viewModel.output.isValidEmail.value {
                    Text("이메일 중복확인을 해주세요.")
                        .font(.Body.body3)
                        .foregroundStyle(.gray90)
                } else {
                    Text("사용 가능한 이메일 입니다.")
                        .font(.Body.body3)
                        .foregroundStyle(.colDeep)
                }
                
                Spacer()
                
                // TODO: 올바른 이메일이 아닐때, 이미 확인이 끝났을때 비활성화
                UnderlineTextButton("이메일 중복확인") {
                    viewModel.action(.validateEmail)
                }
            }
        }
    }
}

// MARK: - PasswordFieldView
extension SignUpView {
    // TODO: 비밀번호 보기버튼 추가
    func passwordFieldView() -> some View {
        VStack {
            RoundedTextField(fieldTitle: "비밀번호", text: $viewModel.input.password, isSecureField: true)
            
            HStack {
                if !viewModel.output.isEnoughPasswordLength.value {
                    Text("비밀번호는 8자 이상이어야 합니다.")
                        .font(.Body.body3)
                        .foregroundStyle(.colRosy)
                } else if !viewModel.output.isValidPassword.value {
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
    
    func validatePasswordFieldView() -> some View {
        VStack {
            RoundedTextField(fieldTitle: "비밀번호 확인", text: $viewModel.input.confirmPassword, isSecureField: true)
            
            HStack {
                if viewModel.output.isConfirmPassword.value {
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

// MARK: - NicknameFieldView
extension SignUpView {
    func nicknameFieldView() -> some View {
        VStack {
            RoundedTextField(fieldTitle: "닉네임", text: $viewModel.input.nickname)
            
            HStack {
                if viewModel.output.isValidNickname.value {
                    Text("사용 가능한 닉네입 입니다.")
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

// MARK: - JoinButton
extension SignUpView {
    func joinButtonView() -> some View {
        ActionButton(text: "가입하기") {
            // TODO: 가입처리 및 로그인
            viewModel.action(.join)
        }
        .padding(.bottom, 18)
    }
}

#if DEBUG
#Preview {
    SignUpView(viewModel: SignUpViewModel(userRepository: UserRepository.shared))
}
#endif
