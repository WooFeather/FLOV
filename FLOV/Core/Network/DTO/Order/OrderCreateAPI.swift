//
//  OrderCreateAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/17/25.
//

import Foundation

// MARK: - OrderCreateRequest
struct OrderCreateRequest: Encodable {
    let activityId: String
    let reservationItemName: String
    let reservationItemTime: String
    let participantCount: Int
    let totalPrice: Int
    
    enum CodingKeys: String, CodingKey {
        case activityId = "activity_id"
        case reservationItemName = "reservation_item_name"
        case reservationItemTime = "reservation_item_time"
        case participantCount = "participant_count"
        case totalPrice = "total_price"
    }
}

// MARK: - OrderCreateResponse
struct OrderCreateResponse: Decodable {
    let orderId: String
    let orderCode: String
    let totalPrice: Int
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case orderCode = "order_code"
        case totalPrice = "total_price"
        case createdAt
        case updatedAt
    }
}

// MARK: - Mapper
extension OrderCreateResponse {
    func toEntity() -> OrderEntity {
        return .init(
            orderId: orderId,
            orderCode: orderCode,
            totalPrice: totalPrice,
            review: nil,
            reservationItemName: nil,
            reservationItemTime: nil,
            participantCount: nil,
            activity: nil,
            paidAt: nil,
            createdAt: createdAt.toIsoDate() ?? Date(),
            updatedAt: updatedAt.toIsoDate() ?? Date()
        )
    }
}
