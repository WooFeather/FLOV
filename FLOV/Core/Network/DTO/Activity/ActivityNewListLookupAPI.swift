//
//  ActivityNewListLookupAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/20/25.
//

import Foundation

// MARK: - ActivityNewListLookupResponse
struct ActivityNewListLookupResponse: Decodable {
    let data: [ActivitySummary]
}

// MARK: - Mapper
extension ActivityNewListLookupResponse {
    func toEntity() -> ActivityListEntity {
        return ActivityListEntity(
            data: data.map { $0.toEntity() },
            nextCursor: nil
        )
    }
}
