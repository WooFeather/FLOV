//
//  AuthManager.swift
//  FLOV
//
//  Created by 조우현 on 5/23/25.
//

import Foundation

@preconcurrency
final class AuthManager: ObservableObject {
    @Published private(set) var isSigned: Bool
    
    init() {
        // 앱 런치 시, 토큰 보유 여부로 초기 로그인 상태 결정
        self.isSigned = TokenManager.shared.refreshToken != nil
    }
    
    @MainActor
    func signInSucceeded(access: String, refresh: String) {
        TokenManager.shared.updateAuthTokens(access: access, refresh: refresh)
        isSigned = true
    }
    
    @MainActor
    func signOut() {
        TokenManager.shared.clearAuthTokens()
        TokenManager.shared.clearFCMToken()
        isSigned = false
    }
}
