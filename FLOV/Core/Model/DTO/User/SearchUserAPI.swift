//
//  SearchUserAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/19/25.
//

import Foundation

// MARK: - SearchUserResponse
struct SearchUserResponse: Decodable {
    let data: [SearchUserData]
}

// MARK: - SearchUserData
struct SearchUserData: Decodable {
    let userId: String
    let nick: String
    let profileImage: String?
    let introduction: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
        case introduction
    }
}
