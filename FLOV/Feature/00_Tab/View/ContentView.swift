//
//  ContentView.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import SwiftUI
import AuthenticationServices

struct ContentView: View {
    var body: some View {
        VStack {
            Button {
                print("카카오로그인탭")
            } label: {
                Image(.kakaoLogin)
                    .resizable()
                    .frame(width : UIScreen.main.bounds.width * 0.9, height: 56)
                    .clipShape (
                        RoundedRectangle(cornerRadius: 8)
                    )
            }
            
            ZStack {
                SignInWithAppleButton { request in
                    print(request)
                    print("찐애플로그인탭")
                } onCompletion: { result in
                    print(result)
                }
                .frame(width : UIScreen.main.bounds.width * 0.9, height:54)
                .clipShape (
                    RoundedRectangle(cornerRadius: 8)
                )
                
                Button {
                    print("커스텀애플로그인탭")
                } label: {
                    Image(.appleLogin)
                        .resizable()
                        .frame(width : UIScreen.main.bounds.width * 0.9, height: 56)
                        .clipShape (
                            RoundedRectangle(cornerRadius: 8)
                        )
                }
                .allowsHitTesting(false)
            }
        }
    }
}

#Preview {
    ContentView()
}
