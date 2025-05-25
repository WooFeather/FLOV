//
//  PriceView.swift
//  FLOV
//
//  Created by 조우현 on 5/25/25.
//

import SwiftUI

struct PriceView: View {
    var originPrice: Int
    var finalPrice: Int
    private var discountPercentage: Int {
        guard originPrice > 0 else { return 0 }
        let rate = Double(originPrice - finalPrice) / Double(originPrice) * 100
        return Int(rate.rounded())
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Text("\(originPrice)원")
                .font(.Body.body1.bold())
                .foregroundColor(.gray30)
                .padding(.trailing)
                .overlay {
                    Image(.imgDiscountArrow)
                        .resizable()
                        .frame(height: 6)
                }
            
            Text("\(finalPrice)원")
                .font(.Body.body1.bold())
                .foregroundColor(.gray90)
            
            Text("\(discountPercentage)%")
                .font(.Body.body1.bold())
                .foregroundColor(.colBlack)
        }
    }
}

#Preview {
    PriceView(
        originPrice: 1000,
        finalPrice: 500
    )
}
