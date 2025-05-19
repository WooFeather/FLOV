//
//  NetworkManager.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation
import Alamofire

protocol NetworkManagerType {
    func callRequest<T: Decodable, U: Router>(_ api: U) async throws -> T
    func uploadMultipart<T: Decodable, U: Router>(_ api: U, formDataBuilder: @escaping (MultipartFormData) -> Void) async throws -> T
    func callWithRefresh<T: Decodable>(_ api: Router, as type: T.Type) async throws -> T
    func uploadMultipartWithRefresh<T: Decodable>(_ api: Router, as type: T.Type, formDataBuilder: @escaping (MultipartFormData) -> Void) async throws -> T
}

final class NetworkManager: NetworkManagerType {
    private let tokenManager: TokenManager
    
    init(tokenManager: TokenManager) {
        self.tokenManager = tokenManager
    }
    
    func callRequest<T: Decodable, U: Router>(_ api: U) async throws -> T {
        // 서버 응답(Data + HTTPURLResponse)
        let dataResponse = await AF.request(api)
            .serializingData()
            .response
        
        let status = dataResponse.response?.statusCode ?? -1
        guard let data = dataResponse.data else {
            throw NetworkError.transport(URLError(.badServerResponse))
        }
        
        // 상태코드 분기처리
        if (200..<300).contains(status) {
            do {
                let decoded: T = try JSONDecoder().decode(T.self, from: data)
                NetworkLog.success(url: api.path, statusCode: status, data: decoded)
                return decoded
            } catch {
                throw NetworkError.decoding(error)
            }
        } else {
            if let errModel = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                NetworkLog.failure(url: api.path, statusCode: status, data: errModel)
                switch status {
                case 418:
                    throw NetworkError.statusCode(418)
                case 419:
                    throw NetworkError.statusCode(419)
                default:
                    throw NetworkError.apiError(errModel.message)
                }
            } else {
                throw NetworkError.statusCode(status)
            }
        }
    }
    
    func uploadMultipart<T: Decodable, U: Router>(_ api: U, formDataBuilder: @escaping (MultipartFormData) -> Void) async throws -> T {
        // Multipart 업로드 요청 → Data + HTTPURLResponse 수신
        let dataResponse = await AF.upload(
            multipartFormData: formDataBuilder,
            with: try api.asURLRequest()
        )
            .serializingData()
            .response
        
        // 상태 코드, Data 추출
        let status = dataResponse.response?.statusCode ?? -1
        guard let data = dataResponse.data else {
            throw NetworkError.transport(URLError(.badServerResponse))
        }
        
        // 상태코드 분기처리
        if (200..<300).contains(status) {
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decoding(error)
            }
        } else {
            if let errModel = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                NetworkLog.failure(url: api.path, statusCode: status, data: errModel)
                switch status {
                case 418:
                    throw NetworkError.statusCode(418)
                case 419:
                    throw NetworkError.statusCode(419)
                default:
                    throw NetworkError.apiError(errModel.message)
                }
            } else {
                throw NetworkError.statusCode(status)
            }
        }
    }
}

extension NetworkManager {
    /// 액세스 토큰을 갱신한 이후 요청하는 메서드
    func callWithRefresh<T: Decodable>(_ api: Router, as type: T.Type) async throws -> T {
        do {
            return try await self.callRequest(api)
        } catch let error as NetworkError {
            switch error {
            case .statusCode(419):
                break
            default:
                throw error
            }
        } catch {
            throw error
        }
        
        // 액세스 토큰 갱신
        do {
            let refreshResponse: RefreshResponse = try await callRequest(AuthAPI.refresh)
            tokenManager.updateAuthTokens(
                access: refreshResponse.accessToken,
                refresh: refreshResponse.refreshToken
            )
            
            return try await self.callRequest(api)
        } catch let error as NetworkError {
            switch error {
            case .statusCode(418):
                UserDefaultsManager.isSigned = false
                throw NetworkError.refreshTokenExpired
            default:
                throw error
            }
        } catch {
            throw error
        }
    }
}

extension NetworkManager {
    /// multipart 요청에서 토큰 만료 시 자동 갱신 후 재시도
    func uploadMultipartWithRefresh<T: Decodable>(_ api: Router, as type: T.Type, formDataBuilder: @escaping (MultipartFormData) -> Void) async throws -> T {
        do {
            return try await self.uploadMultipart(api, formDataBuilder: formDataBuilder)
        } catch let error as NetworkError {
            switch error {
            case .statusCode(419):
                break
            default:
                throw error
            }
        } catch {
            throw error
        }
        
        // 액세스 토큰 갱신
        do {
            let refreshResponse: RefreshResponse = try await callRequest(AuthAPI.refresh)
            tokenManager.updateAuthTokens(
                access: refreshResponse.accessToken,
                refresh: refreshResponse.refreshToken
            )
            
            return try await self.uploadMultipart(api, formDataBuilder: formDataBuilder)
        } catch let error as NetworkError {
            switch error {
            case .statusCode(418):
                UserDefaultsManager.isSigned = false
                throw NetworkError.refreshTokenExpired
            default:
                throw error
            }
        } catch {
            throw error
        }
    }
}
