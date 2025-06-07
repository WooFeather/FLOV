//
//  ChatListLookupAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/4/25.
//

import Foundation

// MARK: - ChatListLookupResponse
/// chattListLookup과 messageListLookup 공용DTO
struct ListLookupResponse: Decodable {
    let data: [ChatRoomResponse]
}
