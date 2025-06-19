//
//  OrderAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/17/25.
//

import Foundation
import Alamofire

enum OrderAPI {
    case orderCreate(request: OrderCreateRequest)
    case orderLookup
}

extension OrderAPI: Router {
    var path: String {
        switch self {
        case .orderCreate, .orderLookup:
            return "/v1/orders"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .orderCreate:
            return .post
        case .orderLookup:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .orderCreate:
            return [
                "Authorization": UserSecurityManager.shared.accessToken ?? "",
                "SeSACKey": Config.sesacKey,
                "Content-Type": "application/json"
            ]
        case .orderLookup:
            return [
                "Authorization": UserSecurityManager.shared.accessToken ?? "",
                "SeSACKey": Config.sesacKey
            ]
        }
    }
    
    var requestBody: Encodable? {
        switch self {
        case .orderCreate(let request):
            return request
        case .orderLookup:
            return nil
        }
    }
}
