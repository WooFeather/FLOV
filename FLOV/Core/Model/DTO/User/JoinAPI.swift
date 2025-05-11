//
//  JoinAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

struct JoinRequest: Encodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String?
    let introduction: String?
    let deviceToken: String?
}

struct JoinResponse: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let accessToken: String
    let refreshToken: String
}
