//
//  ProfileLookupAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

// MARK: - ProfileLookupResponse
struct ProfileLookupResponse: Decodable {
    let userId: String
    let email: String?
    let nick: String
    let profileImage: String?
    let phoneNum: String?
    let introduction: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case profileImage
        case phoneNum
        case introduction
    }
}

// MARK: - Mapper
extension ProfileLookupResponse {
    func toEntity() -> UserEntity {
        return UserEntity(
            id: userId,
            email: email,
            nick: nick,
            profileImageURL: profileImage,
            phoneNumber: phoneNum,
            introduction: introduction
        )
    }
}
