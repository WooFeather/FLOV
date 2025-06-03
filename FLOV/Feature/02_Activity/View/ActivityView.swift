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
            viewModel.action(.fetchNewActivities)
            viewModel.action(.fetchRecommendedActivities)
        }
    }
}

// MARK: - NewActivity
private extension ActivityView {
    func newActivityView() -> some View {
        VStack {
            newActivityHeader()
            
            if viewModel.output.isLoadingNew {
                ProgressView()
                    .frame(height: 300)
            } else {
                newActivityCarousel()
            }
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
        let cardWidthRatio: CGFloat = 0.8 // 화면 너비의 80%
        let cardHeight: CGFloat = 300
        let spacing: CGFloat = -30 // 카드 사이 간격
        let minScale: CGFloat = 0.7 // 옆 카드 최소 스케일
        
        return GeometryReader { geo in
            let screenWidth = geo.size.width
            let cardWidth = screenWidth * cardWidthRatio
            let sidePadding = (screenWidth - cardWidth) / 2
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: spacing) {
                    ForEach(viewModel.output.newActivities, id: \.id) { activity in
                        GeometryReader { itemGeo in
                            let midX = itemGeo.frame(in: .global).midX
                            let distance = abs(midX - screenWidth/2)
                            let scale = max(minScale, 1 - distance / screenWidth)
                            
                            newActivityCard(activity: activity)
                                .frame(width: cardWidth, height: cardHeight)
                                .scaleEffect(scale)
                                .animation(.easeOut(duration: 0.25), value: scale)
                                .overlay {
                                    if viewModel.output.loadingDetails.contains(activity.id) {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                            .padding()
                                    }
                                }
                                .asButton {
                                    pathModel.push(.activityDetail(id: activity.id))
                                }
                        }
                        .frame(width: cardWidth, height: cardHeight)
                        .onAppear {
                            viewModel.action(.fetchActivityDetail(id: activity.id))
                        }
                    }
                }
                .padding(.horizontal, sidePadding)
            }
        }
        .frame(height: cardHeight)
    }
    
    func newActivityCard(activity: ActivitySummaryEntity) -> some View {
        KFRemoteImageView(
            path: activity.thumbnailURLs[0],
            aspectRatio: 1,
            cachePolicy: .memoryOnly,
            height: 300
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    LocationTag(location: activity.country)
                    Spacer()
                }
                
                Spacer()
                
                Text(activity.title)
                    .font(.Body.body0)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                HStack(spacing: 2) {
                    Image(.icnWonWhite)
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text("\(activity.finalPrice)원")
                        .font(.Caption.caption0)
                        .foregroundStyle(.white)
                }
                
                Text(viewModel.output.activityDetails[activity.id]?.description ?? "...")
                    .font(.Caption.caption1)
                    .foregroundStyle(.gray30)
                    .lineLimit(3)
            }
            .shadow(radius: 2)
            .padding()
        }
    }
}

// MARK: - RecommendedActivity
private extension ActivityView {
    func recommendedActivityView() -> some View {
        VStack {
            SectionHeader(title: "추천 액티비티")
            recommendedActivityList()
        }
    }
    
    func recommendedActivityList() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(viewModel.output.recommendedActivities, id: \.id) { activity in
                    let description = viewModel.output.activityDetails[activity.id]?.description
                    
                    ActivityCard(
                        isRecommended: true,
                        activity: activity,
                        description: description
                    ) { isKeep in
                        viewModel.action(.keepToggle(id: activity.id, keepStatus: isKeep))
                    }
                    .onAppear {
                        viewModel.action(.fetchActivityDetail(id: activity.id))
                    }
                    .asButton {
                        pathModel.push(.activityDetail(id: activity.id))
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - AllActivity
private extension ActivityView {
    func allActivityView() -> some View {
        VStack {
            SectionHeader(title: "전체 액티비티")
            filterButtonsView()
            
            if viewModel.output.isLoadingAll {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 200)
            } else if viewModel.output.allActivities.isEmpty {
                EmptyResultView()
            } else {
                allActivityList()
            }
        }
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
                    .asRoundedBackground(
                        cornerRadius: 10,
                        strokeColor: viewModel.output.selectedCountry == country ? Color.colDeep : Color.gray30
                    )
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
                                .stroke(viewModel.output.selectedActivityType == type ? Color.colDeep : Color.gray30, lineWidth: 2)
                        )
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal)
        }
    }
    
    func allActivityList() -> some View {
        LazyVStack(spacing: 20) {
            ForEach(viewModel.output.allActivities, id: \.id) { activity in
                let description = viewModel.output.activityDetails[activity.id]?.description
                let orderCount = viewModel.output.activityDetails[activity.id]?.totalOrderCount
                
                ActivityCard(
                    isRecommended: false,
                    activity: activity,
                    description: description,
                    orderCount: orderCount
                ) { isKeep in
                    viewModel.action(.keepToggle(id: activity.id, keepStatus: isKeep))
                }
                .onAppear {
                    viewModel.action(.fetchActivityDetail(id: activity.id))
                    
                    if activity.id == viewModel.output.allActivities.last?.id,
                       viewModel.output.nextCursor != nil {
                        viewModel.action(.fetchMoreActivities)
                    }
                }
                .asButton {
                    pathModel.push(.activityDetail(id: activity.id))
                }
            }
            
            if viewModel.output.isLodingMore {
                ProgressView()
                    .padding()
            }
        }
        .padding()
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
