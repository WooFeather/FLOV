//
//  JoinAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

// MARK: - JoinRequest
struct JoinRequest: Encodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String?
    let introduction: String?
    let deviceToken: String?
}


// MARK: - JoinResponse
struct JoinResponse: Decodable {
    let userId: String
    let email: String
    let nick: String
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case accessToken
        case refreshToken
    }
}

// MARK: - Mapper
extension JoinResponse {
    func toEntity() -> AuthResultEntity {
        let user = UserEntity(
            id: userId,
            email: email,
            nick: nick,
            profileImageURL: nil,
            phoneNumber: nil,
            introduction: nil
        )
        
        let credentials = AuthCredentialsEntity(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
        
        return AuthResultEntity(user: user, credentials: credentials)
    }
}
