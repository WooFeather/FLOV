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
        Text("distanceView")
    }
    
    func listView() -> some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.output.posts, id: \.postId) { post in
                Text(post.title)
            }
        }
        .padding(.horizontal)
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
