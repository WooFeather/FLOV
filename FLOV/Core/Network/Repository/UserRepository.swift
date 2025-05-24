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
        _ = try await networkManager.callWithRefresh(UserAPI.deviceTokenUpdate(request: request), as: EmptyResponse.self)
    }
    
    func profileLookup() async throws -> UserEntity {
        let response: ProfileLookupResponse = try await networkManager.callWithRefresh(UserAPI.profileLookup, as: ProfileLookupResponse.self)
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func profileUpdate(request: ProfileUpdateRequest) async throws -> UserEntity {
        let response: ProfileUpdateResponse = try await networkManager.callWithRefresh(UserAPI.profileUpdate(request: request), as: ProfileUpdateResponse.self)
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func profileImageUpload(data: Data) async throws -> ProfileImageEntity {
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
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func searchUser(_ nick: String) async throws -> [UserEntity] {
        let response: SearchUserResponse = try await networkManager.callWithRefresh(UserAPI.searchUser(nick: nick), as: SearchUserResponse.self)
        
        let entity = response.toEntity()
        
        return entity
    }
}
