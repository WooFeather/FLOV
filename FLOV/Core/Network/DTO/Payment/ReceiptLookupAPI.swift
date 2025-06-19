//
//  ReceiptLookupAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/19/25.
//

import Foundation

// MARK: - ReceiptLookupAPI
struct ReceiptLookupResponse: Decodable {
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
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case impUid = "imp_uid"
        case merchantUid = "merchant_uid"
        case payMethod = "pay_method"
        case channel
        case pgProvider = "pg_provider"
        case embPgProvider = "emb_pg_provider"
        case pgTid = "pg_tid"
        case pgId = "pg_id"
        case escrow
        case applyNum = "apply_num"
        case bankCode = "bank_code"
        case bankName = "bank_name"
        case cardCode = "card_code"
        case cardName = "card_name"
        case cardQuota = "card_quota"
        case cardNumber = "card_number"
        case cardType = "card_type"
        case vbankCode = "vbank_code"
        case vbankName = "vbank_name"
        case vbankNum = "vbank_num"
        case vbankHolder = "vbank_holder"
        case name
        case amount
        case currency
        case buyerName = "buyer_name"
        case buyerEmail = "buyer_email"
        case buyerTel = "buyer_tel"
        case buyerAddr = "buyer_addr"
        case buyerPostcode = "buyer_postcode"
        case customData = "custom_data"
        case userAgent = "user_agent"
        case status
        case startedAt
        case paidAt
        case receiptUrl = "receipt_url"
        case createdAt
        case updatedAt
    }
}

// MARK: - Mapper
extension ReceiptLookupResponse {
    func toEntity() -> ReceiptEntity {
        return .init(
            impUid: impUid,
            merchantUid: merchantUid,
            payMethod: payMethod,
            channel: channel,
            pgProvider: pgProvider,
            embPgProvider: embPgProvider,
            pgTid: pgTid,
            pgId: pgId,
            escrow: escrow,
            applyNum: applyNum,
            bankCode: bankCode,
            bankName: bankName,
            cardCode: cardCode,
            cardName: cardName,
            cardQuota: cardQuota,
            cardNumber: cardNumber,
            cardType: cardType,
            vbankCode: vbankCode,
            vbankName: vbankName,
            vbankNum: vbankNum,
            vbankHolder: vbankHolder,
            name: name,
            amount: amount,
            currency: currency,
            buyerName: buyerName,
            buyerEmail: buyerEmail,
            buyerTel: buyerTel,
            buyerAddr: buyerAddr,
            buyerPostcode: buyerPostcode,
            customData: customData,
            userAgent: userAgent,
            status: status,
            startedAt: startedAt,
            paidAt: paidAt,
            receiptUrl: receiptUrl,
            createdAt: createdAt?.toIsoDate(),
            updatedAt: updatedAt?.toIsoDate()
        )
    }
}
