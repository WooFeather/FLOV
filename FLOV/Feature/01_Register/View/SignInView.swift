//
//  SignInView.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @StateObject var viewModel: SignInViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                logoView()
                loginButtonView()
                Spacer()
            }
            .padding(.top, 88)
            .padding(.horizontal)
            .asNavigationToolbar()
            .onReceive(viewModel.output.loginSuccess) { _ in
                // TODO: PathModel을 통해 fullScreen 닫기
                // TODO: 토스트메세지 띄우기
                print("로그인 성공")
            }
            .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
                Button("확인", role: .cancel) { }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // TODO: PathModel 적용
                        // pathModel.dismissFullScreenCover()
                    } label: {
                        Image(.icnClose)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Sign In")
                        .foregroundStyle(.colDeep)
                        .font(.Caption.caption0)
                }
            }
        }
    }
}

// MARK: - Logo
private extension SignInView {
    func logoView() -> some View {
        VStack(spacing: 16) {
            Text("액티비티에 빠지다")
                .font(.Body.body0)
                .foregroundStyle(.colDeep)
            
            Image(.flovLogo)
                .resizable()
                .frame(width: 75, height: 22)
        }
    }
}

// MARK: - LoginButton
private extension SignInView {
    func loginButtonView() -> some View {
        VStack(spacing: 16) {
            KakaoLoginButton {
                viewModel.action(.kakaoLogin)
            }
            
            AppleLoginButton()
                .overlay {
                    SignInWithAppleButton { request in
                        request.requestedScopes = [.email, .fullName]
                    } onCompletion: { result in
                        viewModel.action(.appleLogin(result: result))
                    }
                    .blendMode(.color)
                }
            
            Button {
                // TODO: 화면전환 -> 굳이 viewModel로 넘겨야하나?
                viewModel.action(.emailLogin)
            } label: {
                Text("이메일로 시작하기")
                    .font(.Body.body1.bold())
                    .foregroundStyle(.colDeep)
            }
        }
        .padding(.top, 114)
    }
}

#if DEBUG
#Preview {
    SignInView(
        viewModel: SignInViewModel(
            userRepository: UserRepository.shared
        )
    )
}
#endif
