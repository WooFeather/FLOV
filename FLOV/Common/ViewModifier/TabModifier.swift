//
//  TabModifier.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI

struct TabModifier: ViewModifier {
    
    let selectedTab: FlovTab
    
    func body(content: Content) -> some View {
        content
            .tag(selectedTab)
            .tabItem {
                selectedTab.icon
            }
    }
}

extension View {
    func asTabModifier(_ selectedTab: FlovTab) -> some View {
        modifier(TabModifier(selectedTab: selectedTab))
    }
}
