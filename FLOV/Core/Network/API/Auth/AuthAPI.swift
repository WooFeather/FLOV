//
//  AuthAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation
import Alamofire

enum AuthAPI {
    case refresh
}

extension AuthAPI: Router {
    var path: String {
        switch self {
        case .refresh:
            return "/v1/auth/refresh"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .refresh:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .refresh:
            return [
                "accept": "application/json",
                "RefreshToken": TokenManager.shared.refreshToken ?? "",
                "Authorization": TokenManager.shared.accessToken ?? "",
                "SeSACKey": Config.sesacKey
            ]
        }
    }
}
