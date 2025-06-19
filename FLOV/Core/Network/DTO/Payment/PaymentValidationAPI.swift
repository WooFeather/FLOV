//
//  PaymentValidationAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/19/25.
//

import Foundation

// MARK: - PaymentValidationRequest
struct PaymentValidationRequest: Encodable {
    let impUid: String
    
    enum CodingKeys: String, CodingKey {
        case impUid = "imp_uid"
    }
}

// MARK: - PaymentValidationResponse
struct PaymentValidationResponse: Decodable {
    let paymentId: String
    let orderItem: OrderResponse
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case paymentId = "payment_id"
        case orderItem = "order_item"
        case createdAt
        case updatedAt
    }
}

// MARK: - Mapper
extension PaymentValidationResponse {
    func toEntity() -> PaymentEntity {
        return .init(
            paymentId: paymentId,
            orderItem: orderItem.toEntity(),
            createdAt: createdAt.toIsoDate() ?? Date(),
            updatedAt: updatedAt.toIsoDate() ?? Date()
        )
    }
}
