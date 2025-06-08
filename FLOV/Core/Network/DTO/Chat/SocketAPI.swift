//
//  SocketAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/5/25.
//

import Foundation

// MARK: - SocketMessageResponse
struct SocketMessageResponse: Decodable {
    let chatId: String
    let roomId: String
    let content: String
    let createdAt: Date
    let updatedAt: Date
    let sender: SocketUserResponse
    let files: [String]
    
    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case roomId = "room_id"
        case content
        case createdAt
        case updatedAt
        case sender
        case files
    }
}

// MARK: - SocketUserResponse
struct SocketUserResponse: Codable {
    let userId: String
    let nick: String
    let profileImage: String?
    let introduction: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
        case introduction
    }
}

// MARK: - Mapper
extension SocketMessageResponse {
    func toEntity() -> ChatMessageEntity {
        return ChatMessageEntity(
            chatId: chatId,
            roomId: roomId,
            content: content,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sender: sender.toEntity(),
            files: files
        )
    }
}

extension SocketUserResponse {
    func toEntity() -> UserEntity {
        return UserEntity(
            id: userId,
            email: nil,
            nick: nick,
            profileImageURL: profileImage,
            phoneNumber: nil,
            introduction: introduction
        )
    }
}
