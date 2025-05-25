//
//  PointView.swift
//  FLOV
//
//  Created by 조우현 on 5/25/25.
//

import SwiftUI

struct PointView: View {
    var point: Int
    
    var body: some View {
        HStack(spacing: 2) {
            Image(.icnPoint)
                .resizable()
                .frame(width: 20, height: 20)
            
            Text("\(point)P")
                .font(.Body.body1.bold())
                .foregroundColor(.gray90)
        }
    }
}

#Preview {
    PointView(point: 200)
}
