//
//  PaymentAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/19/25.
//

import Foundation
import Alamofire

enum PaymentAPI {
    case paymentValidation(request: PaymentValidationRequest)
    case receiptLookup(orderCode: String)
}

extension PaymentAPI: Router {
    var path: String {
        switch self {
        case .paymentValidation:
            return "/v1/payments/validation"
        case .receiptLookup(let orderCode):
            return "/v1/payments/\(orderCode)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .paymentValidation:
            return .post
        case .receiptLookup:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .paymentValidation:
            return [
                "Authorization": UserSecurityManager.shared.accessToken ?? "",
                "SeSACKey": Config.sesacKey,
                "Content-Type": "application/json"
            ]
        case .receiptLookup:
            return [
                "Authorization": UserSecurityManager.shared.accessToken ?? "",
                "SeSACKey": Config.sesacKey
            ]
        }
    }
    
    var params: Parameters {
        switch self {
        case .paymentValidation:
            return [:]
        case .receiptLookup(let orderCode):
            return ["order_code": orderCode]
        }
    }
    
    var requestBody: Encodable? {
        switch self {
        case .paymentValidation(let request):
            return request
        case .receiptLookup:
            return nil
        }
    }
}
