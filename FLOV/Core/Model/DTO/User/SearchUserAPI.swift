//
//  SearchUserAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/19/25.
//

import Foundation

struct SearchUserResponse: Decodable {
    let data: [User]
}

struct User: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
    let introduction: String?
}
