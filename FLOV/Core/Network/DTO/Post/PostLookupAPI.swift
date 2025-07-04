//
//  PostLookupAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/21/25.
//

import Foundation

// MARK: - PostLookupResponse
/// postLookup, userPostLookup, likePostLookup 공용 DTO
struct PostLookupResponse: Decodable {
    let data: [PostSummary]
    let nextCursor: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}

struct PostSummary: Decodable {
    let postId: String
    let country: String
    let category: String
    let title: String
    let content: String
    let activity: PostActivitySummary?
    let geolocation: ActivityGeolocation
    let creator: UserInfo
    let files: [String]
    let isLike: Bool
    let likeCount: Int
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case country
        case category
        case title
        case content
        case activity
        case geolocation
        case creator
        case files
        case isLike = "is_like"
        case likeCount = "like_count"
        case createdAt
        case updatedAt
    }
}

// MARK: - Mapper
extension PostLookupResponse {
    func toEntity() -> PostListEntity {
        return .init(
            data: data.map { $0.toEntity() },
            nextCursor: nextCursor
        )
    }
}

extension PostSummary {
    func toEntity() -> PostEntity {
        return .init(
            postId: postId,
            country: country,
            category: category,
            title: title,
            content: content,
            activity: activity?.toEntity(),
            location: (
                geolocation.latitude,
                geolocation.longitude
            ),
            creator: creator.toEntity(),
            files: files,
            isLike: isLike,
            likeCount: likeCount,
            comments: nil,
            createdAt: createdAt.toIsoDate() ?? Date(),
            updatedAt: updatedAt.toIsoDate() ?? Date()
        )
    }
}
