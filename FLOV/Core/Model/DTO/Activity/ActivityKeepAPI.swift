//
//  ActivityKeepAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/20/25.
//

import Foundation

// MARK: - ActivityKeepRequest
struct ActivityKeepRequest: Encodable {
    let keepStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case keepStatus = "keep_status"
    }
}

// MARK: - ActivityKeepResponse
struct ActivityKeepResponse: Decodable {
    let keepStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case keepStatus = "keep_status"
    }
}
