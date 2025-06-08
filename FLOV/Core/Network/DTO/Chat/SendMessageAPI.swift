//
//  SendMessageAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/4/25.
//

import Foundation

// MARK: - SendMessageRequest
struct SendMessageRequest: Encodable {
    let content: String
    let files: [String]?
}

// MARK: - SendMessageResponse
/// ChatRoomResponse로 대체
