//
//  TokenManager.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

final class TokenManager {
    static let shared = TokenManager()
    private let defaults = UserDefaults.standard

    private enum Key: String {
        case kakaoToken, appleToken, accessToken, refreshToken
    }

    // Social Tokens
    var kakaoToken: String? {
        get { defaults.string(forKey: Key.kakaoToken.rawValue) }
        set { defaults.setValue(newValue, forKey: Key.kakaoToken.rawValue) }
    }

    var appleToken: String? {
        get { defaults.string(forKey: Key.appleToken.rawValue) }
        set { defaults.setValue(newValue, forKey: Key.appleToken.rawValue) }
    }

    // Auth Tokens
    var accessToken: String? {
        get { defaults.string(forKey: Key.accessToken.rawValue) }
        set { defaults.setValue(newValue, forKey: Key.accessToken.rawValue) }
    }

    var refreshToken: String? {
        get { defaults.string(forKey: Key.refreshToken.rawValue) }
        set { defaults.setValue(newValue, forKey: Key.refreshToken.rawValue) }
    }

    // 로그인 후 토큰 업데이트
    func updateAuthTokens(access: String, refresh: String) {
        accessToken  = access
        refreshToken = refresh
    }

    // 로그아웃 시 토큰 삭제
    func clearAuthTokens() {
        defaults.removeObject(forKey: Key.accessToken.rawValue)
        defaults.removeObject(forKey: Key.refreshToken.rawValue)
    }
}
