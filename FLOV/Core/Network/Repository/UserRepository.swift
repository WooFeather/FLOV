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
    enum UserError: Error {
        case server(message: String)
        case network
        case decoding
        case statusCode(Int)
        case unknown
    }
    
    static let shared: UserRepositoryType = UserRepository()
    private let networkManager: NetworkManagerType = NetworkManager.shared
    private let tokenManager = TokenManager.shared
    
    private init() {}
    
    func emailValidate(request: EmailValidateRequest) async throws -> EmailValidateResponse {
        try await execute {
            try await self.networkManager.callRequest(UserAPI.emailValidate(request: request))
        }
    }
    
    func join(request: JoinRequest) async throws -> JoinResponse {
        try await execute {
            let response: JoinResponse = try await self.networkManager.callRequest(UserAPI.join(request: request))
            
            self.tokenManager.updateAuthTokens(
                access: response.accessToken,
                refresh: response.refreshToken
            )
            
            return response
        }
    }
    
    func login(request: LoginRequest) async throws -> LoginResponse {
        try await execute {
            let response: LoginResponse = try await self.networkManager.callRequest(UserAPI.login(request: request))
            
            self.tokenManager.updateAuthTokens(
                access: response.accessToken,
                refresh: response.refreshToken
            )
            
            return response
        }
    }
    
    func kakaoLogin(request: KakaoLoginRequest) async throws -> KakaoLoginResponse {
        try await execute {
            let response: KakaoLoginResponse = try await self.networkManager.callRequest(UserAPI.kakaoLogin(request: request))
            
            self.tokenManager.updateAuthTokens(
                access: response.accessToken,
                refresh: response.refreshToken
            )
            
            return response
        }
    }
    
    func appleLogin(request: AppleLoginRequest) async throws -> AppleLoginResponse {
        try await execute {
            let response: AppleLoginResponse = try await self.networkManager.callRequest(UserAPI.appleLogin(request: request))
            
            self.tokenManager.updateAuthTokens(
                access: response.accessToken,
                refresh: response.refreshToken
            )
            
            return response
        }
    }
    
    func profileLookup() async throws -> ProfileLookupResponse {
        try await execute {
            try await self.networkManager.callWithRefresh(UserAPI.profileLookup, as: ProfileLookupResponse.self)
        }
    }
}

private extension UserRepository {
    func execute<T>(_ work: @escaping () async throws -> T) async throws -> T {
        do {
            return try await work()
        } catch NetworkError.apiError(let msg) {
            throw UserError.server(message: msg)
        } catch NetworkError.transport {
            throw UserError.network
        } catch NetworkError.decoding {
            throw UserError.decoding
        } catch NetworkError.statusCode(let code) {
            throw UserError.statusCode(code)
        } catch {
            throw UserError.unknown
        }
    }
}
