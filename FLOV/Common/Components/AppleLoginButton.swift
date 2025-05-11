//
//  AppleLoginButton.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import SwiftUI

struct AppleLoginButton: View {
    
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

#Preview {
    KakaoLoginButton(tapAction: {})
    AppleLoginButton()
}
