//
//  AuthRepository.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

protocol AuthRepositoryType {
    func refresh() async throws -> RefreshResponse
}

final class AuthRepository: AuthRepositoryType {
    private let networkManager: NetworkManagerType
    private let tokenManager: UserSecurityManager
    
    init(networkManager: NetworkManagerType, tokenManager: UserSecurityManager) {
        self.networkManager = networkManager
        self.tokenManager = tokenManager
    }
    
    func refresh() async throws -> RefreshResponse {
        let response: RefreshResponse = try await networkManager.callRequest(AuthAPI.refresh)
        
        tokenManager.updateAuthTokens(
            access: response.accessToken,
            refresh: response.refreshToken
        )
        
        return response
    }
}
