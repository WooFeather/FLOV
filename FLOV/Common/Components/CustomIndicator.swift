//
//  CustomIndicator.swift
//  FLOV
//
//  Created by 조우현 on 5/31/25.
//

import SwiftUI

struct CustomIndicator: View {
    let count: Int
    let currentIndex: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .frame(width: currentIndex == index ? 28 : 6,
                           height: 6)
                    .foregroundColor(currentIndex == index ? .gray90 : .gray75)
                    .opacity(currentIndex == index ? 0.5 : 0.3)
            }
        }
        .shadow(color: .white, radius: 2)
        .padding(.bottom, 100)
        .animation(.easeInOut, value: currentIndex)
    }
}

#Preview {
    CustomIndicator(count: 10, currentIndex: 0)
}
