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
        .ignoresSafeArea()
    }
}

// MARK: - DetailInfo
private extension ActivityDetailView {
    func detailInfoView() -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                thumbnailView()
                headerView()
                curriculumView()
                reservationView()
            }
        }
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
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.clear,
                        Color.white.opacity(0.3),
                        Color.white.opacity(0.5),
                        Color.white.opacity(0.8),
                        Color.white
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 120)
            }
        }
        .offset(y: -50)
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
        .offset(y: -170)
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
        HStack {
            restrictionComponents(.age, value: "\(viewModel.output.activityDetails.restrictions.minAge)세")
            Spacer()
            restrictionComponents(.height, value: "\(viewModel.output.activityDetails.restrictions.minHeight)cm")
            Spacer()
            restrictionComponents(.people, value: "\(viewModel.output.activityDetails.restrictions.maxParticipants)명")
        }
        .padding()
        .asRoundedBackground(cornerRadius: 16, strokeColor: .gray30)
    }
    
    func restrictionComponents(_ restriction: Restrictions, value: String) -> some View {
        HStack(spacing: 8) {
            Image(restriction.icon)
                .resizable()
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(restriction.title)
                    .font(.Caption.caption2)
                    .foregroundStyle(.gray45)
                
                Text(value)
                    .font(.Body.body3.bold())
                    .foregroundStyle(.gray75)
            }
        }
    }
    
    func priceView() -> some View {
        VStack {
            // TODO: 새로운 PriceView로 변경
            LargePriceView(
                originPrice: viewModel.output.activityDetails.summary.originalPrice,
                finalPrice: viewModel.output.activityDetails.summary.finalPrice
            )
        }
    }
    
    enum Restrictions {
        case age
        case height
        case people
        
        var icon: ImageResource {
            switch self {
            case .age:
                return .restrictionAge
            case .height:
                return .restrictionHeight
            case .people:
                return .restrictionPeople
            }
        }
        
        var title: String {
            switch self {
            case .age:
                return "연령제한"
            case .height:
                return "신장제한"
            case .people:
                return "최대참가인원"
            }
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
        HStack {
            Text("\(viewModel.output.activityDetails.summary.finalPrice)원")
                .font(.Title.title1.bold())
                .foregroundStyle(.gray90)
            
            Spacer()
            
            ActionButton(text: "결제하기") {
                // TODO: 결제뷰로 이동
            }
            .frame(width: 140)
        }
        .padding()
        .frame(height: 100, alignment: .top)
        .frame(maxWidth: .infinity)
        .background(
            .ultraThinMaterial,
            in: .rect
        )
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: -4)
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
