//
//  PostView.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI

struct PostView: View {
    @EnvironmentObject var pathModel: PathModel
    @StateObject var viewModel: PostViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                headerView()
                postListView()
                Spacer(minLength: 88)
            }
        }
        .asNavigationToolbar()
        .toolbar {
            ToolbarItem(placement: .principal) {
                toolbarTitle()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                writeButton()
            }
        }
        .onAppear {
            viewModel.action(.fetchPosts)
        }
        .refreshable {
            viewModel.action(.refreshPosts)
        }
    }
}

// MARK: - HeaderView
private extension PostView {
    func headerView() -> some View {
        VStack {
            AdBannerView(banners: viewModel.output.ads)
            filterView()
        }
    }
    
    func filterView() -> some View {
        VStack {
            Text("filterView")
            
            if !viewModel.output.infoMessage.isEmpty {
                Text(viewModel.output.infoMessage)
            }
        }
    }
}

// MARK: - PostListView
private extension PostView {
    func postListView() -> some View {
        VStack {
            distanceView()
            if viewModel.output.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.output.posts.isEmpty {
                EmptyResultView(text: "주변의 게시글이 없습니다.\n범위를 조정해주세요.")
            } else {
                listView()
            }
            
            if let errorMessage = viewModel.output.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
    
    func distanceView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Text("Distance")
                    .font(.Body.body3.bold())
                    .foregroundColor(.gray45)
                
                Text("\(viewModel.output.selectedDistance.formatDistance())KM")
                    .font(.Body.body3.bold())
                    .foregroundColor(.colDeep)
            }
            
            DistanceSlider(
                selectedDistance: viewModel.output.selectedDistance,
                onDistanceChanged: { distance in
                    viewModel.action(.setDistance(distance))
                }
            )
            .padding()
            .asRoundedBackground(cornerRadius: 8, strokeColor: .gray45)
        }
        .padding()
    }
    
    func listView() -> some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.output.posts, id: \.postId) { post in
                postRowView(post)
            }
        }
        .padding(.horizontal)
    }
    
    func postRowView(_ post: PostEntity) -> some View {
        VStack(alignment: .leading) {
            KFRemoteImageView(
                path: post.files[0],
                aspectRatio: 1,
                cachePolicy: .memoryAndDiskWithOriginal,
                height: 160
            )
            
            Text(post.title)
                .font(.Body.body3.bold())
                .foregroundStyle(.gray90)
            
            Text(post.content)
                .font(.Caption.caption1.weight(.regular))
                .foregroundStyle(.gray60)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .frame(height: 40)
        }
    }
}

// MARK: - Toolbar
private extension PostView {
    func toolbarTitle() -> some View {
        Text("POST")
            .foregroundStyle(.colDeep)
            .font(.Caption.caption0)
            .lineLimit(1)
    }
    
    func writeButton() -> some View {
        Image(.icnWrite)
            .resizable()
            .frame(width: 32, height: 32)
            .asButton {
                pathModel.presentFullScreenCover(.postWrite)
            }
    }
}

// MARK: - Distance Slider Component
struct DistanceSlider: View {
    let selectedDistance: Int
    let onDistanceChanged: (Int) -> Void
    
    // 5km, 10km, 50km, 100km, 500km
    private let distanceSteps = [5000, 10000, 50000, 100000, 500000]
    
    @State private var sliderValue: Double = 0
    @State private var isDragging: Bool = false
    
    var body: some View {
        // 슬라이더
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 배경 트랙
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray30)
                    .frame(height: 14)
                
                // 활성 트랙
                RoundedRectangle(cornerRadius: 10)
                    .fill(.colDeep)
                    .frame(width: geometry.size.width * CGFloat(sliderValue / 4), height: 14)
                
                // 슬라이더 핸들
                Circle()
                    .fill(.white)
                    .frame(width: 10, height: 10)
                    .offset(x: geometry.size.width * CGFloat(sliderValue / 4) - 12)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                isDragging = true
                                let newValue = min(max(0, value.location.x / geometry.size.width * 4), 4)
                                let roundedValue = round(newValue)
                                sliderValue = roundedValue
                            }
                            .onEnded { _ in
                                isDragging = false
                                let stepIndex = Int(sliderValue)
                                let distance = distanceSteps[stepIndex]
                                onDistanceChanged(distance)
                            }
                    )
            }
            .frame(height: 12)
        }
        .onAppear {
            if let index = distanceSteps.firstIndex(of: selectedDistance) {
                sliderValue = Double(index)
            }
        }
        .onChange(of: selectedDistance) { newDistance in
            if let index = distanceSteps.firstIndex(of: newDistance) {
                sliderValue = Double(index)
            }
        }
    }
}
