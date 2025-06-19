//
//  OrderEntity.swift
//  FLOV
//
//  Created by 조우현 on 6/19/25.
//

import Foundation

struct OrderEntity {
    let orderId: String
    let orderCode: String
    let totalPrice: Int
    let review: ReviewEntity?
    let reservationItemName: String?
    let reservationItemTime: String?
    let participantCount: Int?
    let activity: ActivitySummaryEntity?
    let paidAt: Date?
    let createdAt: Date
    let updatedAt: Date
}

struct ReviewEntity {
    let id: String
    let rating: Int
}
