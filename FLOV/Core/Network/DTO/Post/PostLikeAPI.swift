//
//  PostLikeAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/21/25.
//

import Foundation

// MARK: - PostLikeRequest
struct PostLikeRequest: Encodable {
    let likeStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
}

// MARK: - PostLikeResponse
struct PostLikeResponse: Decodable {
    let likeStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
}

// MARK: - Mapper
extension PostLikeResponse {
    func toEntity() -> PostLikeEntity {
        return .init(likeStatus: likeStatus)
    }
}
