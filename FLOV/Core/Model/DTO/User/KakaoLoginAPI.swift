//
//  KakaoLoginAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

struct KakaoLoginRequest: Encodable {
    let oauthToken: String
    let deviceToken: String?
}

struct KakaoLoginResponse: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String
    let refreshToken: String
}
