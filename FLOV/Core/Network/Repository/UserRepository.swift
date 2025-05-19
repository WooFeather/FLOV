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
    func deviceTokenUpdate(request: DeviceTokenUpdateRequest) async throws
    func profileLookup() async throws -> ProfileLookupResponse
    func profileUpdate(request: ProfileUpdateRequest) async throws -> ProfileUpdateResponse
    func profileImageUpload(data: Data) async throws -> ProfileImageUploadResponse
    func searchUser(_ nick: String) async throws -> SearchUserResponse
}

final class UserRepository: UserRepositoryType {
    private let networkManager: NetworkManagerType
    private let tokenManager: TokenManager
    
    init(networkManager: NetworkManagerType, tokenManager: TokenManager) {
        self.networkManager = networkManager
        self.tokenManager = tokenManager
    }
    
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
    
    func deviceTokenUpdate(request: DeviceTokenUpdateRequest) async throws {
        _ = try await networkManager.callWithRefresh(UserAPI.deviceTokenUpdate(request: request), as: EmptyResponse.self)
        
        // TODO: 토큰이 헤더에 있다면 헤더에서 꺼내기
    }
    
    func profileLookup() async throws -> ProfileLookupResponse {
        try await networkManager.callWithRefresh(UserAPI.profileLookup, as: ProfileLookupResponse.self)
    }
    
    func profileUpdate(request: ProfileUpdateRequest) async throws -> ProfileUpdateResponse {
        try await networkManager.callWithRefresh(UserAPI.profileUpdate(request: request), as: ProfileUpdateResponse.self)
    }
    
    func profileImageUpload(data: Data) async throws -> ProfileImageUploadResponse {
        let response: ProfileImageUploadResponse = try await networkManager.uploadMultipartWithRefresh(
            UserAPI.profileImageUpload,
            as: ProfileImageUploadResponse.self
        ) { form in
            form.append(
                data,
                withName: "profile",
                fileName: "profile.png",
                mimeType: "image/png"
            )
        }
        return response
    }
    
    func searchUser(_ nick: String) async throws -> SearchUserResponse {
        try await networkManager.callWithRefresh(UserAPI.searchUser(nick: nick), as: SearchUserResponse.self)
    }
}
