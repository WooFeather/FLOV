//
//  Font+.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import SwiftUI

extension Font {
    enum Title {
        static let title0: Font = .custom("Paperlogy-9Black", size: 26)
        
        static let title1: Font = .custom("Pretendard-Bold", size: 20)
    }
    
    enum Body {
        static let body0: Font = .custom("Paperlogy-9Black", size: 22)
        
        static let body1: Font = .custom("Pretendard-Medium", size: 16)
        static let body2: Font = .custom("Pretendard-Medium", size: 14)
        static let body3: Font = .custom("Pretendard-Medium", size: 13)
    }
    
    enum Caption {
        static let caption0: Font = .custom("Paperlogy-9Black", size: 16)
        
        static let caption1: Font = .custom("Pretendard-Regular", size: 12)
        static let caption2: Font = .custom("Pretendard-Regular", size: 10)
        static let caption3: Font = .custom("Pretendard-Regular", size: 8)
    }
}
