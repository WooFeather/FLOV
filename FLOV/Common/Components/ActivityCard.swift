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
    
    init(isRecommended: Bool, activity: ActivitySummaryEntity, description: String?, orderCount: Int? = nil, keepButtonTapped: @escaping (Bool) -> Void) {
        self.isRecommended = isRecommended
        self.activity = activity
        self.description = description
        self.orderCount = orderCount
        self.keepButtonTapped = keepButtonTapped
        _isKeep = State(initialValue: activity.isKeep ?? false)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                KFRemoteImageView(
                    path: activity.thumbnailURLs[0],
                    aspectRatio: 18/9,
                    cachePolicy: .memoryAndDiskWithOriginal,
                    height: isRecommended ? 120 : 180
                )
                .asRoundedBackground(cornerRadius: 16, strokeColor: .colLight)
                
                VStack {
                    HStack {
                        Image(isKeep ? .icnLikeFill : .icnLikeEmpty)
                            .asButton {
                                isKeep.toggle()
                                keepButtonTapped(isKeep)
                            }
                        Spacer()
                        LocationTag(location: activity.country ?? "알 수 없음")
                    }
                    
                    Spacer()
                    
                    // TODO: detail의 endDate를 통해 countdown 계산 후 특정 기준을 충족할 경우 .deadline을 보여줌
                    HStack {
                        if let tag = activity.tags.first {
                            if isRecommended {
                                StatusTag(
                                    status: tag.contains("Hot") ? .hot(orderCount: nil) : .new
                                )
                                Spacer()
                            } else {
                                StatusTag(
                                    status: tag.contains("Hot") ? .hot(orderCount: orderCount) : .new,
                                    isLongTag: true
                                )
                                .offset(y: 16)
                            }
                        }
                        
                    }
                }
                .shadow(radius: 2)
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    Text(activity.title ?? "알 수 없음")
                        .font(.Body.body1.bold())
                        .foregroundColor(.gray90)
                        .lineLimit(1)
                    
                    LikeCountView(likeCount: activity.keepCount ?? 0)
                    
                    if !isRecommended {
                        PointView(point: activity.pointReward ?? 0)
                    }
                }
                
                Text(description ?? "설명이 없습니다.")
                    .font(.Caption.caption1)
                    .foregroundColor(.gray60)
                    .lineLimit(2)
                    .frame(minHeight: 40)
                    .multilineTextAlignment(.leading)
                
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
