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
