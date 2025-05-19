//
//  ProfileUpdateAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/19/25.
//

import Foundation

struct ProileUpdateRequest: Encodable {
    let nick: String?
    let profileImage: String?
    let phoneNum: String?
    let introduction: String?
}

struct ProfileUpdateResponse: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let phoneNum: String?
    let introduction: String?
}
