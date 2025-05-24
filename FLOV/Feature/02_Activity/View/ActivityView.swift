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
        ScrollView {
            VStack {
                newActivityView()
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
            activityCarousel()
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
    
    func activityCarousel() -> some View {
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

                            RoundedRectangle(cornerRadius: 20)
                                .fill(colors[idx])
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
        .frame(height: cardHeight + 40)
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
