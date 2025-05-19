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
    case deviceTokenUpdate(request: DeviceTokenUpdateRequest)
    case profileLookup
    case profileUpdate(request: ProileUpdateRequest)
    case profileImageUpload
    case searchUser(nick: String)
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
        case .profileLookup, .profileUpdate:
            return "/v1/users/me/profile"
        case .deviceTokenUpdate:
            return "/v1/users/deviceToken"
        case .profileImageUpload:
            return "/v1/users/profile/image"
        case .searchUser:
            return "/v1/users/search"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .emailValidate, .join, .login, .kakaoLogin, .appleLogin, .profileImageUpload:
            return .post
        case .profileLookup, .searchUser:
            return .get
        case .deviceTokenUpdate, .profileUpdate:
            return .put
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .emailValidate, .join, .login, .kakaoLogin, .appleLogin:
            return [
                "SeSACKey": Config.sesacKey,
                "Content-Type": "application/json"
            ]
        case .profileLookup, .searchUser:
            return [
                "Authorization": TokenManager.shared.accessToken ?? "",
                "SeSACKey": Config.sesacKey
            ]
        case .deviceTokenUpdate, .profileUpdate:
            return [
                "Authorization": TokenManager.shared.accessToken ?? "",
                "SeSACKey": Config.sesacKey,
                "Content-Type": "application/json"
            ]
        case .profileImageUpload:
            return [
                "Authorization": TokenManager.shared.accessToken ?? "",
                "SeSACKey": Config.sesacKey,
                "Content-Type": "multipart/form-data"
            ]
        }
    }
    
    var params: Parameters {
        switch self {
        case .emailValidate, .join, .login, .kakaoLogin, .appleLogin, .deviceTokenUpdate, .profileLookup, .profileUpdate, .profileImageUpload:
            return [:]
        case .searchUser(let nick):
            return [
                "nick": nick
            ]
        }
    }
    
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
        case .deviceTokenUpdate(let request):
            return request
        case .profileUpdate(let request):
            return request
        case .profileImageUpload:
            return nil
        case .searchUser:
            return nil
        }
    }
}
