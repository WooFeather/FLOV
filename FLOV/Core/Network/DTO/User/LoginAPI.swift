//
//  LoginAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

// MARK: - LoginRequest
struct LoginRequest: Encodable {
    let email: String
    let password: String
    let deviceToken: String?
}

// MARK: - LoginResponse
struct LoginResponse: Decodable {
    let userId: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case profileImage
        case accessToken
        case refreshToken
    }
}

// MARK: - Mapper
extension LoginResponse {
    func toEntity() -> AuthResultEntity {
        let user = UserEntity(
            id: userId,
            email: email,
            nick: nick,
            profileImageURL: profileImage,
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
