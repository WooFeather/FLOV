//
//  SignInEmailView.swift
//  FLOV
//
//  Created by 조우현 on 5/13/25.
//

import SwiftUI

struct EmailSignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                inputFieldsView()
                buttonsStackView()
                Spacer()
            }
            .padding(.top, 70)
            .padding(.horizontal)
            .asNavigationToolbar()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // TODO: PathModel 적용
                    } label: {
                        Image(.icnChevron)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Email")
                        .foregroundStyle(.colDeep)
                        .font(.Caption.caption0)
                }
            }
        }
    }
}

// MARK: - InputFields
private extension EmailSignInView {
    func inputFieldsView() -> some View {
        VStack(spacing: 18) {
            emailField()
            passwordField()
        }
    }
}

private extension EmailSignInView {
    func emailField() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("이메일")
                .font(.Body.body2)
                .foregroundStyle(.gray90)
            TextField("", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.colBlack, lineWidth: 1)
                )
        }
    }
    
    func passwordField() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("비밀번호")
                .font(.Body.body2)
                .foregroundStyle(.gray90)
            SecureField("", text: $password)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.colBlack, lineWidth: 1)
                )
        }
    }
}

// MARK: - Buttons
private extension EmailSignInView {
    func buttonsStackView() -> some View {
        VStack(spacing: 16) {
            ActionButton(text: "로그인하기") {
                // TODO: 로그인 로직
            }
            
            ActionButton(text: "이메일로 가입하기", color: .colLight) {
                // TODO: SignUpView로 이동
            }
        }
        .padding(.top, 36)
    }
}


#if DEBUG
#Preview {
    EmailSignInView()
}
#endif
