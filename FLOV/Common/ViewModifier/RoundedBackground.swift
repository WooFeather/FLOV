//
//  RoundedBackground.swift
//  FLOV
//
//  Created by 조우현 on 6/1/25.
//

import SwiftUI

private struct RoundedBackground: ViewModifier {
    var cornerRadius: CGFloat
    var strokeColor: Color
    
    func body(content: Content) -> some View {
        content
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(strokeColor, lineWidth: 2)
            }
            .clipShape(
                RoundedRectangle(cornerRadius: cornerRadius)
            )
    }
}

extension View {
    func asRoundedBackground(cornerRadius: CGFloat, strokeColor: Color) -> some View {
        modifier(RoundedBackground(cornerRadius: cornerRadius, strokeColor: strokeColor))
    }
}
