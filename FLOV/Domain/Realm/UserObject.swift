//
//  UserObject.swift
//  FLOV
//
//  Created by 조우현 on 6/5/25.
//

import Foundation
import RealmSwift


final class UserObject: Object {
    @Persisted(primaryKey: true) var userId: String = ""
    @Persisted var nick: String = ""
    @Persisted var profileImageURL: String? = nil
    @Persisted var introduction: String? = nil
}

// MARK: - Mapper
extension UserObject {
    func toEntity() -> UserEntity {
        return UserEntity(
            id: userId,
            email: nil,
            nick: nick,
            profileImageURL: profileImageURL,
            phoneNumber: nil,
            introduction: introduction
        )
    }
    
    static func from(entity: UserEntity) -> UserObject {
        let object = UserObject()
        object.userId = entity.id
        object.nick = entity.nick
        object.profileImageURL = entity.profileImageURL
        object.introduction = entity.introduction
        return object
    }
}
