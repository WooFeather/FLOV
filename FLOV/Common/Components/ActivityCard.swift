//
//  ActivityCard.swift
//  FLOV
//
//  Created by 조우현 on 5/25/25.
//

import SwiftUI

struct ActivityCard: View {
    var isRecommended: Bool
    var activity: ActivitySummaryEntity
    var description: String?
    var orderCount: Int?
    var keepButtonTapped: (Bool) -> Void
    
    @State private var isKeep: Bool
    
    init(isRecommended: Bool, activity: ActivitySummaryEntity, description: String? = nil, orderCount: Int? = nil, keepButtonTapped: @escaping (Bool) -> Void) {
        self.isRecommended = isRecommended
        self.activity = activity
        self.keepButtonTapped = keepButtonTapped
        _isKeep = State(initialValue: activity.isKeep)
    }
    
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
                        Image(isKeep ? .icnLikeFill : .icnLikeEmpty)
                            .asButton {
                                isKeep.toggle()
                                keepButtonTapped(isKeep)
                            }
                        Spacer()
                        LocationTag(location: activity.country)
                    }
                    
                    Spacer()
                    
                    // TODO: detail의 endDate를 통해 countdown 계산 후 특정 기준을 충족할 경우 .deadline을 보여줌
                    HStack {
                        if isRecommended {
                            StatusTag(
                                status: activity.tags[0].contains("Hot") ? .hot(orderCount: nil) : .new
                            )
                            Spacer()
                        } else {
                            StatusTag(
                                status: activity.tags[0].contains("Hot") ? .hot(orderCount: orderCount) : .new,
                                isLongTag: true
                            )
                            .offset(y: 16)
                        }
                    }
                }
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    Text(activity.title)
                        .font(.Body.body1.bold())
                        .foregroundColor(.gray90)
                        .lineLimit(1)
                    
                    LikeCountView(likeCount: activity.keepCount)
                    
                    if !isRecommended {
                        PointView(point: activity.pointReward ?? 0)
                    }
                }
                
                Text(description ?? "\(activity.tags[0]) & \(activity.category)")
                    .font(.Caption.caption1)
                    .foregroundColor(.gray60)
                    .lineLimit(2)
                
                PriceView(
                    originPrice: activity.originalPrice,
                    finalPrice: activity.finalPrice
                )
            }
        }
        .frame(width: isRecommended ? 240 : nil)
        .frame(maxWidth: isRecommended ? nil : .infinity)
    }
}
