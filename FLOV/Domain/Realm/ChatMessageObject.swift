//
//  ChatMessageObject.swift
//  FLOV
//
//  Created by 조우현 on 6/5/25.
//

import Foundation
import RealmSwift

final class ChatMessageObject: Object {
    @Persisted(primaryKey: true) var chatId: String = ""
    @Persisted var roomId: String = ""
    @Persisted var content: String = ""
    @Persisted var createdAt: Date = Date()
    @Persisted var updatedAt: Date = Date()
    @Persisted var sender: UserObject?
    @Persisted var files = List<String>()
    @Persisted var isRead: Bool = false // 읽음 상태
    @Persisted var messageType: String = "text" // text, image, file 등
}

extension ChatMessageObject {
    func toEntity() -> ChatMessageEntity {
        return ChatMessageEntity(
            chatId: chatId,
            roomId: roomId,
            content: content,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sender: sender?.toEntity() ?? UserEntity(
                id: "",
                email: nil,
                nick: "",
                profileImageURL: nil,
                phoneNumber: nil,
                introduction: nil
            ),
            files: Array(files)
        )
    }
    
    static func from(entity: ChatMessageEntity) -> ChatMessageObject {
        let object = ChatMessageObject()
        object.chatId = entity.chatId
        object.roomId = entity.roomId
        object.content = entity.content
        object.createdAt = entity.createdAt
        object.updatedAt = entity.updatedAt
        object.sender = UserObject.from(entity: entity.sender)
        object.files.append(objectsIn: entity.files)
        return object
    }
}
