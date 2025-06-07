//
//  ChatRoomObject.swift
//  FLOV
//
//  Created by 조우현 on 6/5/25.
//

import Foundation
import RealmSwift

final class ChatRoomObject: Object {
    @Persisted(primaryKey: true) var roomId: String = "" // 방 고유 ID
    @Persisted var createdAt: Date = Date() // 방 생성 시각
    @Persisted var updatedAt: Date = Date() // 방 마지막 업데이트 시각 (ex. 마지막 메시지 시각)
    @Persisted var participants = List<UserObject>() // 방 참여자 정보
    @Persisted var lastChatId: String? = nil
    @Persisted var lastMessageDate: Date? = nil // 마지막 메시지 조회를 위한 필드
}

// MARK: - Mapper
extension ChatRoomObject {
    func toEntity() -> ChatRoomEntity {
        let lastChat: ChatMessageEntity? = {
            if let lastChatId = lastChatId {
                let realm = try! Realm()
                let chatObject = realm.object(ofType: ChatMessageObject.self, forPrimaryKey: lastChatId)
                return chatObject?.toEntity()
            }
            return nil
        }()
        
        return ChatRoomEntity(
            roomId: roomId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            participants: participants.map { $0.toEntity() },
            lastChat: lastChat
        )
    }
    
    static func from(entity: ChatRoomEntity) -> ChatRoomObject {
        let object = ChatRoomObject()
        object.roomId = entity.roomId
        object.createdAt = entity.createdAt
        object.updatedAt = entity.updatedAt
        object.participants.append(objectsIn: entity.participants.map { UserObject.from(entity: $0) })
        object.lastChatId = entity.lastChat?.chatId
        object.lastMessageDate = entity.lastChat?.createdAt
        return object
    }
}
