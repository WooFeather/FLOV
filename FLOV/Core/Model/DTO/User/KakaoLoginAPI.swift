//
//  KakaoLoginAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

// MARK: - KakaoLoginRequest
struct KakaoLoginRequest: Encodable {
    let oauthToken: String
    let deviceToken: String?
}

// MARK: - KakaoLoginResponse
struct KakaoLoginResponse: Decodable {
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
