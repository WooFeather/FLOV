//
//  CustomTabBar.swift
//  FLOV
//
//  Created by 조우현 on 5/17/25.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: FlovTab
    
    var body: some View {
        HStack(alignment: .top, spacing: 54) {
            ForEach(FlovTab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    (selectedTab == tab ? tab.selectedIcon : tab.deselectedIcon)
                        .resizable()
                        .frame(width: 36, height: 36)
                }
            }
        }
        .frame(height: 88, alignment: .top)
        .frame(maxWidth: .infinity)
        .padding(.top, 18)
        .background(Color.white.opacity(0.95))
        .clipShape(
            RoundedCorners(corners: [.topLeft, .topRight], radius: 20)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: -4)
    }
}

struct RoundedCorners: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
