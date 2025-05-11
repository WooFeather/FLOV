//
//  ProfileLookupAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

struct ProfileLookupResponse: Decodable {
    let user_id: String
    let email: String?
    let nick: String
    let profileImage: String?
    let phoneNum: String?
    let introduction: String?
}
