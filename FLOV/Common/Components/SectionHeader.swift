//
//  SectionHeader.swift
//  FLOV
//
//  Created by 조우현 on 6/1/25.
//

import SwiftUI

struct SectionHeader: View {
    var title: String
    var color: Color = .gray90
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(color)
                .font(.Body.body2.bold())
            
            Spacer()
        }
        .padding(.top)
        .padding(.horizontal)
    }
}

#Preview {
    SectionHeader(title: "액티비티")
}
