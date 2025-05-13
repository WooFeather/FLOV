//
//  KakaoLoginButton.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import SwiftUI

struct KakaoLoginButton: View {
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

#if DEBUG
#Preview {
    KakaoLoginButton(tapAction: {})
}
#endif
