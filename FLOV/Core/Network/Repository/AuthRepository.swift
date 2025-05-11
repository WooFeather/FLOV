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
        case server(message: String)
        case network
        case decoding
        case statusCode(Int)
        case unknown
    }
    
    static let shared: AuthRepositoryType = AuthRepository()
    private let networkManager: NetworkManagerType = NetworkManager.shared
    
    private init() {}
    
    func refresh() async throws -> RefreshResponse {
        do {
            let result: RefreshResponse = try await networkManager.callRequest(AuthAPI.refresh)
            return result
        } catch NetworkError.apiError(let msg) {
            throw AuthError.server(message: msg)
        } catch NetworkError.transport {
            throw AuthError.network
        } catch NetworkError.decoding {
            throw AuthError.decoding
        } catch NetworkError.statusCode(let code) {
            throw AuthError.statusCode(code)
        } catch {
            throw AuthError.unknown
        }
    }
}
