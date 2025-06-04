//
//  ChatRoomEntity.swift
//  FLOV
//
//  Created by 조우현 on 6/5/25.
//

import Foundation

struct ChatRoomEntity {
    let roomId: String
    let createdAt: String
    let updatedAt: String
    let participants: [UserEntity]
    let lastChat: ChatMessageEntity?
}

struct ChatMessageEntity {
    let chatId: String
    let roomId: String
    let content: String
    let createdAt: Date
    let updatedAt: Date
    let sender: UserEntity
    let files: [String]
}
