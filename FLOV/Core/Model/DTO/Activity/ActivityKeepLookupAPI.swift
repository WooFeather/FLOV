//
//  ActivityKeepLookupAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/20/25.
//

import Foundation

// MARK: - ActivityKeepLookupResponse
struct ActivityKeepLookupResponse {
    let data: [ActivitySummary]
    let nextCursor: String

    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}
