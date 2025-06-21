//
//  PostModificationAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/21/25.
//

import Foundation

// MARK: - PostModificationRequest
struct PostModificationRequest: Encodable {
    let country: String
    let category: String
    let title: String
    let content: String
    let activityId: String
    let latitude: Double
    let longitude: Double
    let files: [String]
    
    enum CodingKeys: String, CodingKey {
        case country
        case category
        case title
        case content
        case activityId = "activity_id"
        case latitude
        case longitude
        case files
    }
}
