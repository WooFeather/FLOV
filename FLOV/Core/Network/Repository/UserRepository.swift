//
//  UserRepository.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

protocol UserRepositoryType {
    func emailValidate(request: EmailValidateRequest) async throws -> EmailValidationEntity
    func join(request: JoinRequest) async throws -> AuthResultEntity
    func login(request: LoginRequest) async throws -> AuthResultEntity
    func kakaoLogin(request: KakaoLoginRequest) async throws -> AuthResultEntity
    func appleLogin(request: AppleLoginRequest) async throws -> AuthResultEntity
    func deviceTokenUpdate(request: DeviceTokenUpdateRequest) async throws
    func profileLookup() async throws -> UserEntity
    func profileUpdate(request: ProfileUpdateRequest) async throws -> UserEntity
    func profileImageUpload(data: Data) async throws -> ProfileImageEntity
    func searchUser(_ nick: String) async throws -> [UserEntity]
}

final class UserRepository: UserRepositoryType {
    private let networkManager: NetworkManagerType
    private let authManager: AuthManager
    
    init(
        networkManager: NetworkManagerType,
        authManager: AuthManager
    ) {
        self.networkManager = networkManager
        self.authManager = authManager
    }
    
    func emailValidate(request: EmailValidateRequest) async throws -> EmailValidationEntity {
        let response: EmailValidateResponse = try await networkManager.callRequest(UserAPI.emailValidate(request: request))
        
        let entity = response.toEntity()
                
        return entity
    }
    
    func join(request: JoinRequest) async throws -> AuthResultEntity {
        let response: JoinResponse = try await networkManager.callRequest(UserAPI.join(request: request))
        
        await authManager.signInSucceeded(
            access: response.accessToken,
            refresh: response.refreshToken
        )
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func login(request: LoginRequest) async throws -> AuthResultEntity {
        let response: LoginResponse = try await networkManager.callRequest(UserAPI.login(request: request))
        
        await authManager.signInSucceeded(
            access: response.accessToken,
            refresh: response.refreshToken
        )
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func kakaoLogin(request: KakaoLoginRequest) async throws -> AuthResultEntity {
        let response: KakaoLoginResponse = try await networkManager.callRequest(UserAPI.kakaoLogin(request: request))
        
        await authManager.signInSucceeded(
            access: response.accessToken,
            refresh: response.refreshToken
        )
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func appleLogin(request: AppleLoginRequest) async throws -> AuthResultEntity {
        let response: AppleLoginResponse = try await networkManager.callRequest(UserAPI.appleLogin(request: request))
        
        await authManager.signInSucceeded(
            access: response.accessToken,
            refresh: response.refreshToken
        )
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func deviceTokenUpdate(request: DeviceTokenUpdateRequest) async throws {
        _ = try await networkManager.callRequest(UserAPI.deviceTokenUpdate(request: request)) as EmptyResponse
    }
    
    func profileLookup() async throws -> UserEntity {
        let response: ProfileLookupResponse = try await networkManager.callRequest(UserAPI.profileLookup)
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func profileUpdate(request: ProfileUpdateRequest) async throws -> UserEntity {
        let response: ProfileUpdateResponse = try await networkManager.callRequest(UserAPI.profileUpdate(request: request))
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func profileImageUpload(data: Data) async throws -> ProfileImageEntity {
        let response: ProfileImageUploadResponse = try await networkManager.uploadMultipart(UserAPI.profileImageUpload) { form in
            form.append(
                data,
                withName: "profile",
                fileName: "profile.png",
                mimeType: "image/png"
            )
        }
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func searchUser(_ nick: String) async throws -> [UserEntity] {
        let response: SearchUserResponse = try await networkManager.callRequest(UserAPI.searchUser(nick: nick))
        
        let entity = response.toEntity()
        
        return entity
    }
}
