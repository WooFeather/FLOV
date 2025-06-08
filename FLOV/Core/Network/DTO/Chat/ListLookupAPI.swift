//
//  ChatListLookupAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/4/25.
//

import Foundation

// MARK: - ChatListLookupResponse
struct ListLookupResponse: Decodable {
    let data: [ChatRoomResponse]
}
