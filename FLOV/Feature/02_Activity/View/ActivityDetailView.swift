//
//  ActivityDetailView.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI

struct ActivityDetailView: View {
    @EnvironmentObject var pathModel: PathModel
    @StateObject var viewModel: ActivityDetailViewModel
    @State private var currentIndex = 0
    
    var body: some View {
        VStack {
            if viewModel.output.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                detailInfoView()
                paymentView()
            }
        }
        .asNavigationToolbar()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                keepButton()
            }
        }
    }
}

// MARK: - DetailInfo
private extension ActivityDetailView {
    func detailInfoView() -> some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                thumbnailView()
                headerView()
                curriculumView()
                reservationView()
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Thumbnail
private extension ActivityDetailView {
    func thumbnailView() -> some View {
        let urls = viewModel.output.activityDetails.summary.thumbnailURLs
        
        return ZStack {
            TabView(selection: $currentIndex) {
                ForEach(urls.indices, id: \.self) { idx in
                    let path = urls[idx]
                    KFRemoteImageView(
                        path: path,
                        aspectRatio: 3/4,
                        cachePolicy: .memoryOnly,
                        height: 590
                    )
                    .tag(idx)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxWidth: .infinity)
            .frame(height: 590)
            
            VStack {
                Spacer()
                CustomIndicator(count: urls.count, currentIndex: currentIndex)
            }
        }
    }
}

// MARK: - Header
private extension ActivityDetailView {
    func headerView() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.output.activityDetails.summary.title)
                .font(.Body.body0)
                .foregroundStyle(.gray90)
                .lineLimit(1)
            
            HStack(spacing: 12) {
                Text(viewModel.output.activityDetails.summary.country)
                    .font(.Body.body1.bold())
                    .foregroundStyle(.gray60)
                
                PointView(point: viewModel.output.activityDetails.summary.pointReward ?? 0)
                
                // TODO: Review정보
            }
            
            Text(viewModel.output.activityDetails.description ?? "설명이 없습니다.")
                .font(.Caption.caption1)
                .foregroundStyle(.gray60)
                .multilineTextAlignment(.leading)
            
            countView()
            restrictionView()
            priceView()
        }
        .padding()
    }
    
    func countView() -> some View {
        HStack(spacing: 12) {
            HStack(spacing: 2) {
                Image(.icnBuyCount)
                    .resizable()
                    .frame(width: 16, height: 16)
                
                Text("누적 구매 \(viewModel.output.activityDetails.totalOrderCount)회")
                    .font(.Body.body3.weight(.medium))
                    .foregroundStyle(.gray45)
            }
            
            HStack(spacing: 2) {
                Image(.icnKeepCount)
                    .resizable()
                    .frame(width: 16, height: 16)
                
                Text("KEEP \(viewModel.output.activityDetails.summary.keepCount)회")
                    .font(.Body.body3.weight(.medium))
                    .foregroundStyle(.gray45)
            }
        }
    }
    
    func restrictionView() -> some View {
        ZStack {
            VStack {
                Text("연령제한: \(viewModel.output.activityDetails.restrictions.minAge)")
                
                Text("신장제한: \(viewModel.output.activityDetails.restrictions.minHeight)")
                
                Text("최대참가인원: \(viewModel.output.activityDetails.restrictions.maxParticipants)")
            }
        }
    }
    
    func priceView() -> some View {
        VStack {
            // TODO: 새로운 PriceView로 변경
            PriceView(
                originPrice: viewModel.output.activityDetails.summary.originalPrice,
                finalPrice: viewModel.output.activityDetails.summary.finalPrice
            )
        }
    }
}

// MARK: - Curriculum
private extension ActivityDetailView {
    func curriculumView() -> some View {
        VStack {
            
        }
    }
}

// MARK: - Reservation
private extension ActivityDetailView {
    func reservationView() -> some View {
        VStack {
            
        }
    }
}

// MARK: - Payment
private extension ActivityDetailView {
    func paymentView() -> some View {
        ZStack {
            
        }
    }
}

// MARK: - Toolbar
private extension ActivityDetailView {
    func keepButton() -> some View {
        Image(.icnLikeEmpty)
            .asButton {
                // TODO: keepAPI 통신
            }
    }
}
