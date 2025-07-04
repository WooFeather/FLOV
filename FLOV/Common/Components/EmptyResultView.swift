//
//  EmptyResultView.swift
//  FLOV
//
//  Created by 조우현 on 5/28/25.
//

import SwiftUI

struct EmptyResultView: View {
    var text = "결과를 찾을 수 없습니다."
    
    var body: some View {
        VStack {
            Text(text)
                .font(.Caption.caption0)
                .foregroundStyle(.gray60)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    EmptyResultView()
}
