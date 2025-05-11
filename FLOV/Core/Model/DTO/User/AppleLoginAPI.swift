//
//  AppleLoginAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

struct AppleLoginRequest: Encodable {
    let idToken: String
    let deviceToken: String?
    let nick: String?
}

struct AppleLoginResponse: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String
    let refreshToken: String
}
