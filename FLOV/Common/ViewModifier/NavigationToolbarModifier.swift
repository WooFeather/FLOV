//
//  NavigationToolbarModifier.swift
//  FLOV
//
//  Created by 조우현 on 5/13/25.
//

import SwiftUI

private struct NavigationToolbarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
    }
}

extension View {
    public func asNavigationToolbar() -> some View {
        modifier(NavigationToolbarModifier())
    }
}
