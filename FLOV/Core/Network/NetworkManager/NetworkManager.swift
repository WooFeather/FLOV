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
}

final class NetworkManager: NetworkManagerType {
    private let tokenManager: TokenManager
    private let authManager: AuthManager
    private let session: Session
    
    init(tokenManager: TokenManager, authManager: AuthManager, session: Session) {
        self.tokenManager = tokenManager
        self.authManager = authManager
        self.session = session
    }
    
    func callRequest<T: Decodable, U: Router>(_ api: U) async throws -> T {
        let dataResponse = await session.request(api)
            .validate(statusCode: 200..<300) // 이 외의 오류는 AFError로 던짐
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
                NetworkLog.success(url: dataResponse.response?.url?.absoluteString ?? "", statusCode: status, data: decoded)
                return decoded
            } catch {
                throw NetworkError.decoding(error)
            }
        } else {
            if let errModel = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                NetworkLog.failure(url: dataResponse.response?.url?.absoluteString ?? "", statusCode: status, data: errModel)

                switch status {
                case 419:
                    if let afError = dataResponse.error {
                        throw afError
                    } else {
                        throw AFError.responseValidationFailed(
                            reason: .unacceptableStatusCode(code: status)
                        )
                    }
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
        let dataResponse = await session.upload(
            multipartFormData: formDataBuilder,
            with: try api.asURLRequest()
        )
            .validate(statusCode: 200..<300) // 이 외의 오류는 AFError로 던짐
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
                case 419:
                    if let afError = dataResponse.error {
                        throw afError
                    } else {
                        throw AFError.responseValidationFailed(
                            reason: .unacceptableStatusCode(code: status)
                        )
                    }
                default:
                    throw NetworkError.apiError(errModel.message)
                }
            } else {
                throw NetworkError.statusCode(status)
            }
        }
    }
}
