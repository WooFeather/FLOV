//
//  SignInView.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @EnvironmentObject private var pathModel: PathModel
    @StateObject var viewModel: SignInViewModel
    
    var body: some View {
        VStack {
            logoView()
            loginButtonView()
            Spacer()
        }
        .padding(.top, 88)
        .padding(.horizontal)
        .asNavigationToolbar()
        .onChange(of: viewModel.output.loginSuccess) { success in
            if success {
                // TODO: 토스트메세지 띄우기
                pathModel.popToRoot()
            }
        }
        .alert(viewModel.output.alertMessage, isPresented: $viewModel.output.showAlert) {
            Button("확인", role: .cancel) { }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Sign In")
                    .foregroundStyle(.colDeep)
                    .font(.Caption.caption0)
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
                pathModel.push(.emailSignIn)
            } label: {
                Text("이메일로 시작하기")
                    .font(.Body.body1.bold())
                    .foregroundStyle(.colDeep)
            }
        }
        .padding(.top, 114)
    }
}

// MARK: - KakaoLoginButton
private struct KakaoLoginButton: View {
    var tapAction: () -> Void
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            HStack {
                Image(.kakaoIcon)
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Spacer()
                
                Text("카카오로 시작하기")
                    .font(.Body.body1)
                    .foregroundStyle(.kakaoFg)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(.kakaoBg)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

// MARK: - AppleLoginButton
private struct AppleLoginButton: View {
    
    var body: some View {
        Button {
            
        } label: {
            HStack {
                Image(.appleIcon)
                    .resizable()
                    .frame(width: 20, height: 24)
                
                Spacer()
                
                Text("Apple로 시작하기")
                    .font(.Body.body1)
                    .foregroundStyle(.appleFg)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(.appleBg)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}
