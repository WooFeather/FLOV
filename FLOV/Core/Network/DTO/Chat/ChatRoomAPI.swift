//
//  CreateChatAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/4/25.
//

import Foundation

// MARK: - CreateChatRequest
struct CreateChatRequest: Encodable {
    let opponentId: String
    
    enum CodingKeys: String, CodingKey {
        case opponentId = "opponent_id"
    }
}

// MARK: - CreateChatResponse
/// CreateChatResponse, SendMessageResponse 공용 DTO
struct ChatRoomResponse: Decodable {
    let roomId: String
    let createdAt: Date
    let updatedAt: Date
    let participants: [UserInfo]
    let lastChat: ChatMessage?
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case createdAt
        case updatedAt
        case participants
        case lastChat
    }
}

// MARK: - ChatUser
struct UserInfo: Decodable {
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

// MARK: - ChatMessage
struct ChatMessage: Decodable {
    let chatId: String
    let roomId: String
    let content: String
    let createdAt: Date
    let updatedAt: Date
    let sender: UserInfo
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

// MARK: - Mapper
extension ChatRoomResponse {
    func toEntity() -> ChatRoomEntity {
        return .init(
            roomId: roomId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            participants: participants.map {
                .init(
                    id: $0.userId,
                    email: nil,
                    nick: $0.nick,
                    profileImageURL: $0.profileImage,
                    phoneNumber: nil,
                    introduction: $0.introduction
                )
            },
            lastChat: lastChat.map {
                .init(
                    chatId: $0.chatId,
                    roomId: $0.roomId,
                    content: $0.content,
                    createdAt: $0.createdAt,
                    updatedAt: $0.updatedAt,
                    sender: .init(
                        id: $0.sender.userId,
                        email: nil,
                        nick: $0.sender.nick,
                        profileImageURL: $0.sender.profileImage,
                        phoneNumber: nil,
                        introduction: $0.sender.introduction
                    ),
                    files: $0.files
                )
            }
        )
    }
}
