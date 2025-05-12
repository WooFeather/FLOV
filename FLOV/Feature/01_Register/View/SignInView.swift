//
//  SignInView.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import SwiftUI
import AuthenticationServices
import KakaoSDKUser

struct SignInView: View {
    private let userRepository: UserRepositoryType = UserRepository.shared
    private let tokenManager = TokenManager()
    
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
            kakaoLoginView()
            appleLoginView()
            emailLoginView()
        }
        .padding(.top, 114)
    }
}

// MARK: - KakaoLogin
extension SignInView {
    // TODO: 추후 viewModel로 뺄때는 withCheckedThrowingContinuation를 통해 oauthToken을 바로 kakaoLoginAPI로 넘겨서 처리
    // => TokenManager에 카카오, 애플 토큰 저장 로직 삭제
    func kakaoLogin() {
        // 카카오톡 실행 가능 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 로그인
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error {
                    print(error)
                } else {
                    print("카카오톡 로그인 성공")
                    
                    tokenManager.kakaoToken = oauthToken?.accessToken
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error {
                    print(error)
                } else {
                    print("카카오톡 로그인 성공")
                    
                    tokenManager.kakaoToken = oauthToken?.accessToken
                    print("OAuth Token: \(String(describing: oauthToken))")
                }
            }
        }
        
        Task {
            do {
                try await kakaoRequest()
            } catch {
                print(error)
            }
        }
        fetchKakaoUserinfo()
    }
    
    /// 카카오톡 유저정보
    func fetchKakaoUserinfo() {
        UserApi.shared.me { user, error in
            if let email = user?.kakaoAccount?.email {
                print("Email: \(email)")
            }
        }
        // 닉네임과 프로필사진도 처리 가능
    }
    
    /// 카카오톡 연결해제
    func unlikKakao() {
        UserApi.shared.unlink { error in
            if let error {
                print(error)
            } else {
                print("연결해제 성공")
            }
        }
    }
    
    func kakaoRequest() async throws {
        do {
            let response = try await userRepository.kakaoLogin(request: KakaoLoginRequest(oauthToken: tokenManager.kakaoToken ?? "", deviceToken: nil))
            
            dump(response)
        } catch {
            print(error)
        }
    }
    
    func kakaoLoginView() -> some View {
        VStack {
            KakaoLoginButton {
                kakaoLogin()
            }
            
//            Button {
//                unlikKakao()
//            } label: {
//                Text("연결 끊기")
//            }
        }
    }
}

// MARK: - 애플로그인
extension SignInView {
    func appleLoginView() -> some View {
        AppleLoginButton()
            .overlay {
                SignInWithAppleButton { request in
                    request.requestedScopes = [.email, .fullName]
                } onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        print("애플로그인 성공")
                        
                        switch authResults.credential {
                        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                            let idToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                            let fullName = appleIDCredential.fullName
                            let name =  (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                            
                            Task {
                                do {
                                    let response = try await userRepository.appleLogin(
                                        request: AppleLoginRequest(
                                            idToken: idToken ?? "",
                                            deviceToken: nil,
                                            nick: name
                                        )
                                    )
                                    
                                    dump(response)
                                } catch {
                                    print(error)
                                }
                            }
                        default:
                            break
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                .blendMode(.color)
            }
    }
}

// MARK: - 이메일로그인
extension SignInView {
    func emailLoginView() -> some View {
        VStack {
            Button {
                
            } label: {
                Text("이메일로 시작하기")
                    .font(.Body.body1.bold())
                    .foregroundStyle(.colDeep)
            }
//            Button {
//                Task {
//                    do {
//                        let response = try await userRepository.emailValidate(request: EmailValidateRequest(email: "usertest456@test.com"))
//                        
//                        dump(response)
//                    } catch {
//                        print(error)
//                    }
//                }
//            } label: {
//                Text("이메일유효성 검사")
//            }
//            
//            Button {
//                Task {
//                    do {
//                        let response = try await userRepository.join(
//                            request: JoinRequest(
//                                email: "usertest456@test.com",
//                                password: "woohyun123@",
//                                nick: "으하하하",
//                                phoneNum: nil,
//                                introduction: nil,
//                                deviceToken: nil
//                            )
//                        )
//                        
//                        dump(response)
//                    } catch {
//                        print(error)
//                    }
//                }
//            } label: {
//                Text("회원가입")
//            }
//            
//            Button {
//                Task {
//                    do {
//                        let response = try await userRepository.login(
//                            request: LoginRequest(
//                                email: "usertest456@test.com",
//                                password: "woohyun123@",
//                                deviceToken: nil
//                            )
//                        )
//                        dump(response)
//                    } catch {
//                        print(error)
//                    }
//                }
//            } label: {
//                Text("로그인")
//            }
//            
//            Button {
//                Task {
//                    do {
//                        let response = try await userRepository.profileLookup()
//                        dump(response)
//                    } catch {
//                        print(error)
//                    }
//                }
//            } label: {
//                Text("프로필조회")
//            }
        }
    }
}

#if DEBUG
#Preview {
    SignInView()
}
#endif
