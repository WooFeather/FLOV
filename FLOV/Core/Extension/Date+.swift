//
//  Date+.swift
//  FLOV
//
//  Created by 조우현 on 6/2/25.
//

import Foundation

extension Date {
    func toString(format: String) -> String? {
        let dataFormatter = DateFormatter()
        dataFormatter.locale = Locale(identifier: "ko_KR")
        dataFormatter.dateFormat = format
        return dataFormatter.string(from: self)
    }
}
