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
