//
//  AuthInterceptor.swift
//  FLOV
//
//  Created by 조우현 on 5/26/25.
//

import Foundation
import Alamofire

// MARK: - Auth Interceptor
final class AuthInterceptor: RequestInterceptor, @unchecked Sendable {
    private let tokenManager: UserSecurityManager
    private let authManager: AuthManager
    
    // 토큰 갱신 동기화를 위한 프로퍼티들
    private let refreshQueue = DispatchQueue(label: "auth.refresh.queue", qos: .userInitiated)
    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []
    
    init(tokenManager: UserSecurityManager, authManager: AuthManager) {
        self.tokenManager = tokenManager
        self.authManager = authManager
    }
    
    // MARK: - RequestAdapter
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        // 인증이 필요한 요청에 액세스 토큰 추가
        if let accessToken = tokenManager.accessToken {
            urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        }
        
        completion(.success(urlRequest))
    }
    
    // MARK: - RequestRetrier
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        refreshQueue.async {
            // 419 에러(토큰 만료)인지 확인
            guard let response = request.task?.response as? HTTPURLResponse,
                  response.statusCode == 419 else {
                completion(.doNotRetry)
                return
            }
            
            // 이미 토큰 갱신 중이라면 대기열에 추가
            if self.isRefreshing {
                self.requestsToRetry.append(completion)
                return
            }
            
            // 토큰 갱신 시작
            self.isRefreshing = true
            self.refreshToken { [weak self] success in
                guard let self = self else { return }
                
                self.refreshQueue.async {
                    self.isRefreshing = false
                    
                    if success {
                        // 현재 요청과 대기 중인 모든 요청 재시도
                        completion(.retry)
                        for retryCompletion in self.requestsToRetry {
                            retryCompletion(.retry)
                        }
                    } else {
                        // 모든 요청 실패 처리
                        completion(.doNotRetry)
                        for retryCompletion in self.requestsToRetry {
                            retryCompletion(.doNotRetry)
                        }
                    }
                    
                    self.requestsToRetry.removeAll()
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func refreshToken(completion: @escaping (Bool) -> Void) {
        print("[AuthInterceptor] 🔄 시작 – refreshToken 호출")
        guard tokenManager.refreshToken != nil else {
            print("[AuthInterceptor] 🔴 no refresh token")
            completion(false)
            return
        }
        
        AF.request(AuthAPI.refresh)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: RefreshResponse.self) { [weak self] response in
                switch response.result {
                case .success(let dto):
                    print("[AuthInterceptor] ✅ refresh 성공: \(dto.accessToken)")
                    self?.tokenManager.updateAuthTokens(
                        access: dto.accessToken,
                        refresh: dto.refreshToken
                    )
                    completion(true)
                    
                case .failure(let error):
                    print("[AuthInterceptor] 🔴 refresh 실패:", error)
                    if response.response?.statusCode == 418 {
                        Task { await self?.authManager.signOut() }
                    }
                    completion(false)
                }
            }
    }
}
