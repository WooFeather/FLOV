//
//  PostView.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI

struct PostView: View {
    @EnvironmentObject var pathModel: PathModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("PostView")
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
    }
}

// MARK: - HeaderView
private extension PostView {
    func headerView() -> some View {
        VStack {
            Text("액티비티 포스트")
            Text("거리 조절뷰")
        }
    }
}

// MARK: - PostListView
private extension PostView {
    func postListView() -> some View {
        VStack {
            Text("PostListView")
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
