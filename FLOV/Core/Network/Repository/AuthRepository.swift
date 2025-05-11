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
    enum AuthError: Error {
        case invalidToken
        case tokenExpired
        case server(message: String)
        case unknown
    }
    
    static let shared: AuthRepositoryType = AuthRepository()
    private let networkManager: NetworkManagerType = NetworkManager.shared
    
    private init() { }
    
    func refresh() async throws -> RefreshResponse {
        do {
            let result: RefreshResponse = try await networkManager.callRequest(AuthAPI.refresh)
            return result
        } catch NetworkError.apiError(let msg) {
            throw AuthError.server(message: msg)
        } catch NetworkError.statusCode(401) {
            throw AuthError.invalidToken
        } catch NetworkError.statusCode(418) {
            throw AuthError.tokenExpired
        } catch {
            throw AuthError.unknown
        }
    }
}
