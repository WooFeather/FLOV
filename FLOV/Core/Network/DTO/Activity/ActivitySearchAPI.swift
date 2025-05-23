//
//  ActivitySearchAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/20/25.
//

import Foundation

// MARK: - ActivitySearchResponse
struct ActivitySearchResponse: Decodable {
    let data: [ActivitySummary]
}

// MARK: - Mapper
extension ActivitySearchResponse {
    func toEntity() -> ActivityListEntity {
        return ActivityListEntity(
            data: data.map { $0.toEntity() },
            nextCursor: nil
        )
    }
}
