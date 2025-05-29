//
//  TokenManager.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

final class TokenManager: Sendable {
    static let shared = TokenManager()
    private let keychain = KeychainManager.shared

    private enum Key: String {
        case accessToken, refreshToken
    }
    
    private init() {}

    var accessToken: String? {
        get {
            keychain.read(Key.accessToken.rawValue)
        }
        set {
            if let token = newValue {
                keychain.save(token, forKey: Key.accessToken.rawValue)
            } else {
                keychain.delete(Key.accessToken.rawValue)
            }
        }
    }

    var refreshToken: String? {
        get {
            keychain.read(Key.refreshToken.rawValue)
        }
        set {
            if let token = newValue {
                keychain.save(token, forKey: Key.refreshToken.rawValue)
            } else {
                keychain.delete(Key.refreshToken.rawValue)
            }
        }
    }

    // 로그인 후 토큰 업데이트
    func updateAuthTokens(access: String, refresh: String) {
        accessToken = access
        refreshToken = refresh
    }

    // 로그아웃 시 토큰 삭제
    func clearAuthTokens() {
        keychain.delete(Key.accessToken.rawValue)
        keychain.delete(Key.refreshToken.rawValue)
    }
}
