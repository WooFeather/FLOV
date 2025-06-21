//
//  PostSearchAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/21/25.
//

import Foundation

// MARK: - SearchPostResponse
struct PostSearchResponse: Decodable {
    let data: [PostSummary]
}

// MARK: - Mapper
extension PostSearchResponse {
    func toEntity() -> PostListEntity {
        .init(
            data: data.map { $0.toEntity() },
            nextCursor: nil
        )
    }
}
