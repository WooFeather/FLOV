//
//  UserAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation
import Alamofire

enum UserAPI {
    case emailValidate(request: EmailValidateRequest)
    case join(request: JoinRequest)
    case login(request: LoginRequest)
    case kakaoLogin(request: KakaoLoginRequest)
    case appleLogin(request: AppleLoginRequest)
    case profileLookup
}

extension UserAPI: Router {
    var path: String {
        switch self {
        case .emailValidate:
            return "/v1/users/validation/email"
        case .join:
            return "/v1/users/join"
        case .login:
            return "/v1/users/login"
        case .kakaoLogin:
            return "/v1/users/login/kakao"
        case .appleLogin:
            return "/v1/users/login/apple"
        case .profileLookup:
            return "/v1/users/me/profile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .emailValidate, .join, .login, .kakaoLogin, .appleLogin:
            return .post
        case .profileLookup:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .emailValidate, .join, .login, .kakaoLogin, .appleLogin:
            return [
                "SeSACKey": Config.sesacKey,
                "Content-Type": "application/json"
            ]
        case .profileLookup:
            return [
                "Authorization": TokenManager.shared.accessToken ?? "",
                "SeSACKey": Config.sesacKey
            ]
        }
    }
}

extension UserAPI: EncodableRouter {
    var requestBody: Encodable? {
        switch self {
        case .emailValidate(let request):
            return request
        case .join(let request):
            return request
        case .login(let request):
            return request
        case .kakaoLogin(let request):
            return request
        case .appleLogin(let request):
            return request
        case .profileLookup:
            return nil
        }
    }
}
