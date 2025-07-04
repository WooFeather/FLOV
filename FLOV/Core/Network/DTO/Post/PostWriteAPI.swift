//
//  PostWriteAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/21/25.
//

import Foundation

// MARK: - PostWriteRequest
struct PostWriteRequest: Encodable {
    let country: String
    let category: String
    let title: String
    let content: String
    let activityId: String?
    let latitude: Double
    let longitude: Double
    let files: [String]?
    
    enum CodingKeys: String, CodingKey {
        case country
        case category
        case title
        case content
        case activityId = "activity_id"
        case latitude
        case longitude
        case files
    }
}

// MARK: - PostWriteResponse
/// postWrite, postDetailLookup, postModification 공용 DTO
struct PostResponse: Decodable {
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
    let comments: [Comment]
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
        case comments
        case createdAt
        case updatedAt
    }
}

struct PostActivitySummary: Decodable {
    let id: String
    let title: String?
    let country: String?
    let category: String?
    let thumbnails: [String]
    let geolocation: ActivityGeolocation
    let price: ActivityPrice
    let tags: [String]
    let pointReward: Int?
    let isAdvertisement: Bool
    let isKeep: Bool
    let keepCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case country
        case category
        case thumbnails
        case geolocation
        case price
        case tags
        case pointReward = "point_reward"
        case isAdvertisement = "is_advertisement"
        case isKeep = "is_keep"
        case keepCount = "keep_count"
    }
}

struct Comment: Decodable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: UserInfo
    let replies: [Replies] // 1뎁스까지만 포함
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content
        case createdAt
        case creator
        case replies
    }
}

struct Replies: Decodable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: UserInfo
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content
        case createdAt
        case creator
    }
}

// MARK: - Mapper
extension PostResponse {
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
            comments: comments.map { $0.toEntity() },
            createdAt: createdAt.toIsoDate() ?? Date(),
            updatedAt: updatedAt.toIsoDate() ?? Date()
        )
    }
}

extension PostActivitySummary {
    func toEntity() -> ActivitySummaryEntity {
        return .init(
            id: id,
            title: title,
            country: country,
            category: category,
            thumbnailURLs: thumbnails,
            location: (
                geolocation.latitude,
                geolocation.longitude
            ),
            originalPrice: price.original,
            finalPrice: price.final,
            tags: tags,
            pointReward: pointReward,
            isAdvertisement: isAdvertisement
        )
    }
}

extension Comment {
    func toEntity() -> CommentEntity {
        return .init(
            commentId: commentId,
            content: content,
            createdAt: createdAt.toIsoDate() ?? Date(),
            creator: creator.toEntity(),
            replies: replies.map { $0.toEntity() }
        )
    }
}

extension Replies {
    func toEntity() -> RepliesEntity {
        return .init(
            commentId: commentId,
            content: content,
            createdAt: createdAt.toIsoDate() ?? Date(),
            creator: creator.toEntity()
        )
    }
}

extension UserInfo {
    func toEntity() -> UserEntity {
        return .init(
            id: userId,
            email: nil,
            nick: nick,
            profileImageURL: profileImage,
            phoneNumber: nil,
            introduction: introduction
        )
    }
}
