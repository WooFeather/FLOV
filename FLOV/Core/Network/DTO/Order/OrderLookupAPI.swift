//
//  OrderLookupAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/18/25.
//

import Foundation

// MARK: - OrderLookupResponse
struct OrderLookupResponse: Decodable {
    let data: [OrderResponse]
}

struct OrderResponse: Decodable {
    let orderId: String
    let orderCode: String
    let totalPrice: Int
    let review: Review?
    let reservationItemName: String
    let reservationItemTime: String
    let participantCount: Int
    let activity: OrderActivitySummary
    let paidAt: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case orderCode = "order_code"
        case totalPrice = "total_price"
        case review
        case reservationItemName = "reservation_item_name"
        case reservationItemTime = "reservation_item_time"
        case participantCount = "participant_count"
        case activity
        case paidAt
        case createdAt
        case updatedAt
    }
}

struct Review: Decodable {
    let id: String
    let rating: Int
}

struct OrderActivitySummary: Decodable {
    let id: String
    let title: String?
    let country: String?
    let category: String?
    let thumbnails: [String]
    let geolocation: ActivityGeolocation
    let price: ActivityPrice
    let tags: [String]
    let pointReward: Int?
}
