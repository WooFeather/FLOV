//
//  MessageLookupResponse.swift
//  FLOV
//
//  Created by 조우현 on 6/9/25.
//

import Foundation

// MARK: - MessageLookupResponse
struct MessageLookupResponse: Decodable {
    let data: [ChatMessage]
}
