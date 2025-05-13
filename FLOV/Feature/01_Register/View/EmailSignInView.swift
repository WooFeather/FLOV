//
//  SignInEmailView.swift
//  FLOV
//
//  Created by 조우현 on 5/13/25.
//

import SwiftUI

struct EmailSignInView: View {
    @State private var email = ""
    @State private var password = ""
    
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
            RoundedTextField(fieldTitle: "이메일", text: $email, placeholder: "이메일을 입력해주세요")
            RoundedTextField(fieldTitle: "비밀번호", text: $password, placeholder: "비밀번호를 입력해주세요", isSecureField: true)
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
            
            ActionButton(text: "이메일로 가입하기", backgroundColor: .colLight) {
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
