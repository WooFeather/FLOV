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
    func uploadMultipart<T: Decodable, U: Router>(
        _ api: U,
        formDataBuilder: @escaping (MultipartFormData) -> Void
    ) async throws -> T
    func callWithRefresh<T: Decodable>(
        _ api: Router,
        as type: T.Type
    ) async throws -> T
}

final class NetworkManager: NetworkManagerType {
    static let shared: NetworkManagerType = NetworkManager()
    private init() { }
    
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
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decoding(error)
            }
        } else {
            if let errModel = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw NetworkError.apiError(errModel.message)
            } else {
                throw NetworkError.statusCode(status)
            }
        }
    }
    
    func uploadMultipart<T: Decodable, U: Router>(
        _ api: U,
        formDataBuilder: @escaping (MultipartFormData) -> Void
    ) async throws -> T {
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
            if let err = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw NetworkError.apiError(err.message)
            } else {
                throw NetworkError.statusCode(status)
            }
        }
    }
}

extension NetworkManager {
    /// 액세스 토큰을 갱신한 이후 요청하는 메서드
    func callWithRefresh<T: Decodable>(
        _ api: Router,
        as type: T.Type
    ) async throws -> T {
        do {
            return try await self.callRequest(api)
        }
        catch NetworkError.statusCode(let code) where code == 419 {
            // refresh
            let tokens = try await AuthRepository.shared.refresh()
            TokenManager.shared.updateAuthTokens(
                access: tokens.accessToken,
                refresh: tokens.refreshToken
            )
            // retry
            return try await self.callRequest(api)
        }
    }
}
