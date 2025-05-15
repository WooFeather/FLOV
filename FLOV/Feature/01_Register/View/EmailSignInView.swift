//
//  SignInEmailView.swift
//  FLOV
//
//  Created by 조우현 on 5/13/25.
//

import SwiftUI

struct EmailSignInView: View {
    @StateObject var viewModel: EmailSignInViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    inputFieldsView()
                    buttonsStackView()
                    Spacer()
                }
                .padding(.top, 70)
                .padding(.horizontal)
            }
            .asNavigationToolbar()
            .onReceive(viewModel.output.loginSuccess) { _ in
                // TODO: dismiss
                // TODO: 토스트메세지 띄우기
                print("로그인성공")
            }
            .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
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
            RoundedTextField(
                fieldTitle: "이메일",
                text: $viewModel.input.email,
                placeholder: "이메일을 입력해주세요"
            )
            
            // TODO: 비밀번호 보기버튼 추가
            RoundedTextField(
                fieldTitle: "비밀번호",
                text: $viewModel.input.password,
                placeholder: "비밀번호를 입력해주세요",
                isSecureField: true
            )
        }
    }
}

// MARK: - Buttons
private extension EmailSignInView {
    func buttonsStackView() -> some View {
        VStack(spacing: 16) {
            ActionButton(text: "로그인하기") {
                viewModel.action(.login)
            }
            
            ActionButton(text: "이메일로 가입하기", backgroundColor: .colLight) {
                // TODO: 화면전환
                viewModel.action(.signUp)
            }
        }
        .padding(.top, 36)
    }
}

#if DEBUG
#Preview {
    EmailSignInView(viewModel: EmailSignInViewModel(userRepository: UserRepository.shared))
}
#endif
