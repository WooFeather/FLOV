//
//  NotificationView.swift
//  FLOV
//
//  Created by 조우현 on 5/24/25.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var pathModel: PathModel
    @State private var selectedTab: Int = 0
    private let tabs = ["최근 알림", "채팅 내역"]
    
    var body: some View {
        VStack(spacing: 0) {
            tabSwitchView()
            
            TabView(selection: $selectedTab) {
                pathModel.build(.recentNoti)
                    .tag(0)
                pathModel.build(.chatList)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .asNavigationToolbar()
        .toolbar {
            ToolbarItem(placement: .principal) {
                toolbarTitle()
            }
        }
    }
}

// MARK: - TabSwitch
extension NotificationView {
    func tabSwitchView() -> some View {
        HStack {
            ForEach(0..<tabs.count, id: \.self) { idx in
                Text(tabs[idx])
                    .font(.Body.body1)
                    .foregroundColor(selectedTab == idx ? .colBlack : .colDeep)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .asButton {
                        withAnimation { selectedTab = idx }
                    }
            }
        }
        .background(Color.white)
        .overlay(
            GeometryReader { proxy in
                let tabWidth = proxy.size.width / CGFloat(tabs.count)
                Rectangle()
                    .foregroundStyle(.colBlack)
                    .frame(width: tabWidth, height: 2)
                    .offset(x: CGFloat(selectedTab) * tabWidth, y: proxy.size.height - 2)
                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
            }
            , alignment: .bottom
        )
    }
}

// MARK: - Toolbar
extension NotificationView {
    func toolbarTitle() -> some View {
        Text("NOTIFICATION")
            .foregroundStyle(.colDeep)
            .font(.Caption.caption0)
    }
}
