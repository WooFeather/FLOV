//
//  SignUpView.swift
//  FLOV
//
//  Created by 조우현 on 5/13/25.
//

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var nickname = ""
    
    @State private var isValidEmail = false
    @State private var isValidPassword = true
    @State private var isCorrectPassword = false
    @State private var isValidNickname = true
    
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
            RoundedTextField(fieldTitle: "이메일", text: $email)
            
            HStack {
                if !isValidEmail {
                    Text("올바른 이메일 형식이 아닙니다.")
                        .font(.Body.body3)
                        .foregroundStyle(.colRosy)
                }
                
                Spacer()
                UnderlineTextButton("이메일 중복확인") {
                    // TODO: 중복확인 API통신
                    isValidEmail.toggle() // 테스트
                    isValidPassword.toggle()
                }
            }
        }
    }
}

// MARK: - PasswordFieldView
extension SignUpView {
    func passwordFieldView() -> some View {
        VStack {
            RoundedTextField(fieldTitle: "비밀번호", text: $password, isSecureField: true)
            
            HStack {
                if isValidPassword {
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
            RoundedTextField(fieldTitle: "비밀번호 확인", text: $confirmPassword, isSecureField: true)
            
            HStack {
                if !isCorrectPassword {
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
            RoundedTextField(fieldTitle: "닉네임", text: $nickname)
            
            HStack {
                if isValidNickname {
                    Text("사용 가능한 닉네입 입니다.")
                        .font(.Body.body3)
                        .foregroundStyle(.colDeep)
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
        }
        .padding(.bottom, 18)
    }
}

#if DEBUG
#Preview {
    SignUpView()
}
#endif
