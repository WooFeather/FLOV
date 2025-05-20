//
//  AppleLoginAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

// MARK: - AppleLoginRequest
struct AppleLoginRequest: Encodable {
    let idToken: String
    let deviceToken: String?
    let nick: String?
}

// MARK: - AppleLoginResponse
struct AppleLoginResponse: Decodable {
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
