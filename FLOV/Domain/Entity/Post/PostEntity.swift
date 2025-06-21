//
//  PostEntity.swift
//  FLOV
//
//  Created by 조우현 on 6/21/25.
//

import Foundation

struct PostEntity {
    let postId: String
    let country: String
    let category: String
    let title: String
    let content: String
    let activity: ActivitySummaryEntity?
    let location: (latitude: Double, longitude: Double)
    let creator: UserEntity
    let files: [String]
    let isLike: Bool
    let likeCount: Int
    let comments: [CommentEntity]?
    let createdAt: String
    let updatedAt: String
}
