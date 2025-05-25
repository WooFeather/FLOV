//
//  LikeCountView.swift
//  FLOV
//
//  Created by 조우현 on 5/25/25.
//

import SwiftUI

struct LikeCountView: View {
    var likeCount: Int
    
    var body: some View {
        HStack(spacing: 2) {
            Image(.icnLikeFill)
                .resizable()
                .frame(width: 20, height: 20)
            
            Text("\(likeCount)개")
                .font(.Body.body1.bold())
                .foregroundColor(.gray90)
        }
    }
}

#Preview {
    LikeCountView(likeCount: 387)
}
