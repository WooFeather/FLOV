//
//  UserRepository.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

protocol UserRepositoryType {
    func emailValidate(request: EmailValidateRequest) async throws -> EmailValidateResponse
    func join(request: JoinRequest) async throws -> JoinResponse
    func login(request: LoginRequest) async throws -> LoginResponse
    func kakaoLogin(request: KakaoLoginRequest) async throws -> KakaoLoginResponse
    func appleLogin(request: AppleLoginRequest) async throws -> AppleLoginResponse
    func profileLookup() async throws -> ProfileLookupResponse
}

final class UserRepository: UserRepositoryType {
    static let shared: UserRepositoryType = UserRepository()
    private let networkManager: NetworkManagerType = NetworkManager.shared
    private let tokenManager = TokenManager.shared
    
    private init() {}
    
    func emailValidate(request: EmailValidateRequest) async throws -> EmailValidateResponse {
        try await networkManager.callRequest(UserAPI.emailValidate(request: request))
    }
    
    func join(request: JoinRequest) async throws -> JoinResponse {
        let response: JoinResponse = try await networkManager.callRequest(UserAPI.join(request: request))
        
        tokenManager.updateAuthTokens(
            access: response.accessToken,
            refresh: response.refreshToken
        )
        
        return response
    }
    
    func login(request: LoginRequest) async throws -> LoginResponse {
        let response: LoginResponse = try await networkManager.callRequest(UserAPI.login(request: request))
        
        tokenManager.updateAuthTokens(
            access: response.accessToken,
            refresh: response.refreshToken
        )
        
        UserDefaultsManager.isSigned = true
        
        return response
    }
    
    func kakaoLogin(request: KakaoLoginRequest) async throws -> KakaoLoginResponse {
        let response: KakaoLoginResponse = try await networkManager.callRequest(UserAPI.kakaoLogin(request: request))
        
        tokenManager.updateAuthTokens(
            access: response.accessToken,
            refresh: response.refreshToken
        )
        
        UserDefaultsManager.isSigned = true
        
        return response
    }
    
    func appleLogin(request: AppleLoginRequest) async throws -> AppleLoginResponse {
        let response: AppleLoginResponse = try await networkManager.callRequest(UserAPI.appleLogin(request: request))
        
        tokenManager.updateAuthTokens(
            access: response.accessToken,
            refresh: response.refreshToken
        )
        
        UserDefaultsManager.isSigned = true
        
        return response
    }
    
    func profileLookup() async throws -> ProfileLookupResponse {
        try await networkManager.callWithRefresh(UserAPI.profileLookup, as: ProfileLookupResponse.self)
    }
}
