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
    var discountPercentage: Int {
        return calculateDiscountPercentage(originPrice, finalPrice)
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
            
            if discountPercentage > 0 {
                Text("\(discountPercentage)%")
                    .font(.Body.body1.bold())
                    .foregroundColor(.colBlack)
            }
        }
    }
}

struct LargePriceView: View {
    var originPrice: Int
    var finalPrice: Int
    var discountPercentage: Int {
        return calculateDiscountPercentage(originPrice, finalPrice)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(originPrice)원")
                .font(.Caption.caption0)
                .foregroundColor(.gray45)
                .padding(.trailing, 48)
                .overlay {
                    Image(.imgDiscountArrowBent)
                        .resizable()
                        .frame(height: 15)
                        .offset(y: 6)
                }
            
            HStack(spacing: 8) {
                Text("판매가")
                    .font(.Body.body0)
                    .foregroundStyle(.gray45)
                
                Text("\(finalPrice)원")
                    .font(.Body.body0)
                    .foregroundStyle(.gray75)
                
                if discountPercentage > 0 {
                    Text("\(discountPercentage)%")
                        .font(.Body.body0)
                        .foregroundStyle(.colBlack)
                }
            }
        }
    }
}

private func calculateDiscountPercentage(_ originPrice: Int, _ finalPrice: Int) -> Int {
    guard originPrice > 0 else { return 0 }
    let rate = Double(originPrice - finalPrice) / Double(originPrice) * 100
    return Int(rate.rounded())
}

#Preview {
    PriceView(
        originPrice: 1000,
        finalPrice: 500
    )
    LargePriceView(
        originPrice: 341000,
        finalPrice: 123000
    )
}
