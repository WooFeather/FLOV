//
//  CommentEntity.swift
//  FLOV
//
//  Created by 조우현 on 6/21/25.
//

import Foundation

struct CommentEntity {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: UserEntity
    let replies: [RepliesEntity] // 1뎁스까지만 포함
}

struct RepliesEntity {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: UserEntity
}
