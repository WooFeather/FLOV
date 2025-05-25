//
//  LocationTag.swift
//  FLOV
//
//  Created by 조우현 on 5/25/25.
//

import SwiftUI

struct LocationTag: View {
    var location: String
    
    var body: some View {
        HStack(spacing: 2) {
            Image(.icnLocationWhite)
                .resizable()
                .frame(width: 12, height: 12)
            
            Text(location)
                .font(.Caption.caption2.weight(.semibold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.gray45.opacity(0.5))
        .clipShape(Capsule())
    }
}

#Preview {
    LocationTag(location: "스위스 융프라우")
}
