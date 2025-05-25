//
//  ActivityView.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var pathModel: PathModel
    @StateObject var viewModel: ActivityViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                newActivityView()
                recommendedActivityView()
                AdBannerView(banners: viewModel.output.ads)
                allActivityView()
                
                Spacer(minLength: 88)
            }
        }
        .asNavigationToolbar()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                logoImage()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                alertButton()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                searchButton()
            }
        }
        .onAppear {
            viewModel.action(.fetchAllActivities)
        }
    }
}

// MARK: - NewActivity
private extension ActivityView {
    func newActivityView() -> some View {
        VStack {
            newActivityHeader()
            newActivityCarousel()
        }
    }
    
    func newActivityHeader() -> some View {
        HStack {
            Text("NEW 액티비티")
                .foregroundStyle(.gray90)
                .font(.Body.body2.bold())
            
            Spacer()
            
            Text("View All")
                .foregroundStyle(.colDeep)
                .font(.Caption.caption1.bold())
                .asButton {
                    // TODO: allNewActivityView로 이동
                }
        }
        .padding()
    }
    
    func newActivityCarousel() -> some View {
        // TODO: 실제 activity데이터로 변경
        let colors: [Color] = [.red, .green, .blue, .orange, .purple]
        
        let cardWidthRatio: CGFloat = 0.8 // 화면 너비의 80%
        let cardHeight: CGFloat = 300
        let spacing: CGFloat = -30 // 카드 사이 간격
        let minScale: CGFloat = 0.7 // 옆 카드 최소 스케일

        return GeometryReader { geo in
            let screenWidth = geo.size.width
            let cardWidth = screenWidth * cardWidthRatio
            let sidePadding = (screenWidth - cardWidth) / 2

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(colors.indices, id: \.self) { idx in
                        GeometryReader { itemGeo in
                            let midX = itemGeo.frame(in: .global).midX
                            let distance = abs(midX - screenWidth/2)
                            let scale = max(minScale, 1 - distance / screenWidth)
                            
                            newActivityCard(colors: colors, idx: idx)
                                .frame(width: cardWidth, height: cardHeight)
                                .scaleEffect(scale)
                                .animation(.easeOut(duration: 0.25), value: scale)
                        }
                        .frame(width: cardWidth, height: cardHeight)
                    }
                }
                .padding(.horizontal, sidePadding)
            }
        }
        .frame(height: cardHeight)
    }
    
    func newActivityCard(colors: [Color], idx: Int) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(colors[idx])
            .overlay {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        LocationTag(location: "스위스 융프라우")
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Text("겨울 새싹 스키 원정대")
                        .font(.Body.body0)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    
                    HStack(spacing: 2) {
                        Image(.icnWonWhite)
                            .resizable()
                            .frame(width: 16, height: 16)
                        
                        Text("123,000원")
                            .font(.Caption.caption0)
                            .foregroundStyle(.white)
                    }
                    
                    Text("끝없이 펼쳐진 슬로프, 자유롭게 바람을 가르는 시간. 초보자 코스부터 짜릿한 파크존까지, 당신만의 새싹 스키 리듬을 찾아 떠나보세요.")
                        .font(.Caption.caption1)
                        .foregroundStyle(.gray30)
                        .lineLimit(3)
                }
                .padding()
            }
    }
}

// MARK: - RecommendedActivity
private extension ActivityView {
    func recommendedActivityView() -> some View {
        VStack {
            recommendedActivityHeader()
            recommendedActivityList()
        }
    }
    
    func recommendedActivityHeader() -> some View {
        HStack {
            Text("추천 액티비티")
                .foregroundStyle(.gray90)
                .font(.Body.body2.bold())
            
            Spacer()
        }
        .padding(.top)
        .padding(.horizontal)
    }
    
    func recommendedActivityList() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(0..<5) { _ in
                    recommendedActivityCard()
                }
            }
            .padding()
        }
    }
    
    // TODO: 실제 데이터로 교체
    func recommendedActivityCard() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.colDeep)
                    .frame(height: 140)
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
                        StatusTag(status: .hot(orderCount: nil))
                        Spacer()
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
                }
                
                Text("끝없이 펼쳐진 슬로프, 자유롭게 바람을 가르는 시간. 초보자 코스부터 짜릿한 파크존까지, 당신이원하는모든덧어쩌구.....야호")
                    .font(.Caption.caption1)
                    .foregroundColor(.gray60)
                    .lineLimit(2)
                
                PriceView(originPrice: 341000, finalPrice: 123000)
            }
        }
        .frame(width: 240)
    }
}

// MARK: - AllActivity
private extension ActivityView {
    func allActivityView() -> some View {
        VStack {
            allActivityHeader()
            filterButtonsView()
            allActivityList()
        }
    }
    
    func allActivityHeader() -> some View {
        HStack {
            Text("전체 액티비티")
                .foregroundStyle(.gray90)
                .font(.Body.body2.bold())
            
            Spacer()
        }
        .padding(.top)
        .padding(.horizontal)
    }
    
    func filterButtonsView() -> some View {
        VStack {
            countryFilterButtons()
            typeFilterButtons()
        }
    }
    
    func countryFilterButtons() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Country.allCases, id: \.self) { country in
                    HStack(spacing: 6) {
                        Image(uiImage: country.flag)
                            .resizable()
                            .frame(width: 48, height: 48)
                        Text(country.title)
                            .font(.Body.body3.bold())
                            .foregroundStyle(viewModel.output.selectedCountry == country ? .colDeep : .gray75)
                    }
                    .asButton {
                        viewModel.action(.selectCountry(country: country))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 2)
                    .background(viewModel.output.selectedCountry == country ? Color.colDeep.opacity(0.5) : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(viewModel.output.selectedCountry == country ? Color.colDeep : Color.gray30, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal)
        }
    }
    
    func typeFilterButtons() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(ActivityType.allCases, id: \.self) { type in
                    Text(type.title)
                        .asButton {
                            viewModel.action(.selectActivityType(type: type))
                        }
                        .font(.Body.body3.weight(.medium))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                        .foregroundStyle(viewModel.output.selectedActivityType == type ? .colDeep : .gray75)
                        .background(viewModel.output.selectedActivityType == type ? Color.colDeep.opacity(0.5) : Color.white)
                        .overlay(
                            Capsule()
                                .stroke(viewModel.output.selectedActivityType == type ? Color.colDeep : Color.gray30, lineWidth: 1)
                        )
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal)
        }
    }
    
    func allActivityList() -> some View {
        VStack {
            
        }
    }
}

// MARK: - Toolbar
private extension ActivityView {
    func logoImage() -> some View {
        Image(.flovLogo)
            .resizable()
            .frame(width: 80, height: 24)
    }
    
    func alertButton() -> some View {
        Image(.icnNoti)
            .resizable()
            .frame(width: 32, height: 32)
            .asButton {
                pathModel.push(.notification)
            }
    }
    
    func searchButton() -> some View {
        Image(.icnSearch)
            .resizable()
            .frame(width: 32, height: 32)
            .asButton {
                pathModel.push(.search)
            }
    }
}
