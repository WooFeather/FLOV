//
//  PaymentEntity.swift
//  FLOV
//
//  Created by 조우현 on 6/19/25.
//

import Foundation

struct PaymentEntity {
    let paymentId: String
    let orderItem: OrderEntity
    let createdAt: Date
    let updatedAt: Date
}
