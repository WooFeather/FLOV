//
//  ReceiptEntity.swift
//  FLOV
//
//  Created by 조우현 on 6/19/25.
//

import Foundation

struct ReceiptEntity {
    let impUid: String
    let merchantUid: String
    let payMethod: String?
    let channel: String?
    let pgProvider: String?
    let embPgProvider: String?
    let pgTid: String?
    let pgId: String?
    let escrow: Bool?
    let applyNum: String?
    let bankCode: String?
    let bankName: String?
    let cardCode: String?
    let cardName: String?
    let cardQuota: Int?
    let cardNumber: String?
    let cardType: Int?
    let vbankCode: String?
    let vbankName: String?
    let vbankNum: String?
    let vbankHolder: String?
    let name: String?
    let amount: Int
    let currency: String
    let buyerName: String?
    let buyerEmail: String?
    let buyerTel: String?
    let buyerAddr: String?
    let buyerPostcode: String?
    let customData: String?
    let userAgent: String?
    let status: String
    let startedAt: String?
    let paidAt: String?
    let receiptUrl: String?
    let createdAt: Date?
    let updatedAt: Date?
}
