//
//  SignInView.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    private let userRepository: UserRepositoryType = UserRepository.shared
    private let authRepository: AuthRepositoryType = AuthRepository.shared
    
    var body: some View {
        VStack {
            KakaoLoginButton {
                print("카카오버튼 탭")
            }
            
            AppleLoginButton()
                .overlay {
                    SignInWithAppleButton { request in
                        print(request)
                        print("애플버튼 탭")
                    } onCompletion: { result in
                        print(result)
                    }
                    .blendMode(.overlay)
                }
            
            Button {
                Task {
                    do {
                        let response = try await userRepository.emailValidate(request: EmailValidateRequest(email: "usertest456@test.com"))
                        
                        dump(response)
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("이메일유효성 검사")
            }
            
            Button {
                Task {
                    do {
                        let response = try await userRepository.join(
                            request: JoinRequest(
                                email: "usertest456@test.com",
                                password: "woohyun123@",
                                nick: "으하하하",
                                phoneNum: nil,
                                introduction: nil,
                                deviceToken: nil
                            )
                        )
                        
                        dump(response)
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("회원가입")
            }
            
            Button {
                Task {
                    do {
                        let response = try await userRepository.login(
                            request: LoginRequest(
                                email: "usertest456@test.com",
                                password: "woohyun123@",
                                deviceToken: nil
                            )
                        )
                        dump(response)
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("로그인")
            }
            
            Button {
                Task {
                    do {
                        let response = try await userRepository.profileLookup()
                        dump(response)
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("프로필조회")
            }
            
            Button {
                Task {
                    do {
                        let response = try await authRepository.refresh()
                        dump(response)
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("토큰갱신")
            }
        }
        .padding()
    }
}

#Preview {
    SignInView()
}
