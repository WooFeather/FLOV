//
//  SignInView.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
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
        }
        .padding()
    }
}

#Preview {
    SignInView()
}
