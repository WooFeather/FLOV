//
//  ActivityFileUploadResponse.swift
//  FLOV
//
//  Created by 조우현 on 5/19/25.
//

import Foundation

// MARK: - ActivityFileUploadResponse
struct ActivityFileUploadResponse: Decodable {
    let thumbnails: [String]
}

// MARK: - Mapper
extension ActivityFileUploadResponse {
    func toEntity() -> ActivityFileUploadEntity {
        return ActivityFileUploadEntity(thumbnails: thumbnails)
    }
}
