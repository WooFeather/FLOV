//
//  ActivityCard.swift
//  FLOV
//
//  Created by 조우현 on 5/25/25.
//

import SwiftUI

// TODO: Entity를 매개변수로 받아서 실제 데이터 로드
struct ActivityCard: View {
    var isRecommended: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.colDeep)
                    .aspectRatio(16/9, contentMode: .fill)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.colLight, lineWidth: 4)
                    )
                
                VStack {
                    HStack {
                        Image(.icnLikeEmpty)
                            .asButton {
                                // TODO: 좋아요 로직
                            }
                        Spacer()
                        LocationTag(location: "스위스 융프라우")
                    }
                    
                    Spacer()
                    
                    HStack {
                        if isRecommended {
                            StatusTag(status: .hot(orderCount: nil))
                            Spacer()
                        } else {
                            StatusTag(status: .new, isLongTag: true)
                                .offset(y: 16)
                        }
                    }
                }
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    Text("겨울 새싹 스키 원정대")
                        .font(.Body.body1.bold())
                        .foregroundColor(.gray90)
                        .lineLimit(1)
                    
                    LikeCountView(likeCount: 387)
                    
                    if !isRecommended {
                        PointView(point: 200)
                    }
                }
                
                Text("끝없이 펼쳐진 슬로프, 자유롭게 바람을 가르는 시간. 초보자 코스부터 짜릿한 파크존까지, 당신이원하는모든덧어쩌구.....야호")
                    .font(.Caption.caption1)
                    .foregroundColor(.gray60)
                    .lineLimit(2)
                
                PriceView(originPrice: 341000, finalPrice: 123000)
            }
        }
        .frame(width: isRecommended ? 240 : nil)
        .frame(maxWidth: isRecommended ? nil : .infinity)
    }
}

#Preview {
    ActivityCard(isRecommended: true)
    ActivityCard(isRecommended: false)
}
