//
//  ActivityListLookupAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/19/25.
//

import Foundation

// MARK: - ActivityListLookupResponse
struct ActivityListLookupResponse: Decodable {
    let data: [ActivitySummary]
    let nextCursor: String

    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}

// MARK: - ActivityListLookupData
struct ActivitySummary: Decodable {
    let activityId: String
    let title: String?
    let country: String?
    let category: String?
    let thumbnails: [String]
    let geolocation: ActivityGeolocation
    let price: ActivityPrice
    let tags: [String]
    let pointReward: Int?
    let isAdvertisement: Bool
    let isKeep: Bool
    let keepCount: Int

    enum CodingKeys: String, CodingKey {
        case activityId = "activity_id"
        case title
        case country
        case category
        case thumbnails
        case geolocation
        case price
        case tags
        case pointReward = "point_reward"
        case isAdvertisement = "is_advertisement"
        case isKeep = "is_keep"
        case keepCount = "keep_count"
    }
}

// MARK: - ActivityGeolocation
struct ActivityGeolocation: Decodable {
    let longitude: Double
    let latitude: Double
}

// MARK: - ActivityPrice
struct ActivityPrice: Decodable {
    let original: Int
    let final: Int
}

