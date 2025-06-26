//
//  Int.swift
//  FLOV
//
//  Created by 조우현 on 5/25/25.
//

import Foundation

extension Int {
    var twoDigits: String { String(format: "%02d", self) }
    
    func formatDistance() -> String {
        let km = Double(self) / 1000.0
        if km == floor(km) {
            return String(Int(km))
        } else {
            return String(format: "%.1f", km)
        }
    }
}
