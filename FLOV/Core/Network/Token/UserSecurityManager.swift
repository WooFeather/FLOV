//
//  TokenManager.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation
import FirebaseMessaging

final class UserSecurityManager: Sendable {
    static let shared = UserSecurityManager()
    private let keychain = KeychainManager.shared

    private enum Key: String {
        case accessToken, refreshToken, fcmToken, userId
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
    
    var fcmToken: String? {
        get {
            keychain.read(Key.fcmToken.rawValue)
        }
        set {
            if let token = newValue {
                keychain.save(token, forKey: Key.fcmToken.rawValue)
            } else {
                keychain.delete(Key.fcmToken.rawValue)
            }
        }
    }
    
    var userId: String? {
        get {
            keychain.read(Key.userId.rawValue)
        }
        set {
            if let id = newValue {
                keychain.save(id, forKey: Key.userId.rawValue)
            } else {
                keychain.delete(Key.userId.rawValue)
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
    
    // fcm토큰 요청
    func fetchFCMToken() async throws -> String {
        // 이미 저장된 토큰이 있으면 바로 리턴
        if let saved = fcmToken {
            return saved
        }
        // 없으면 SDK에 요청
        return try await withCheckedThrowingContinuation { continuation in
            Messaging.messaging().token { token, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let token = token {
                    self.fcmToken = token
                    continuation.resume(returning: token)
                } else {
                    continuation.resume(throwing: NSError(
                        domain: "TokenManager",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "FCM token is nil"]))
                }
            }
        }
    }
    
    func clearFCMToken() {
        keychain.delete(Key.fcmToken.rawValue)
        Messaging.messaging().deleteToken { error in
            if let error = error {
              print("FCM deleteToken 실패:", error)
            } else {
              print("FCM 토큰 삭제 완료")
            }
        }
    }
    
    func clearUserId() {
        keychain.delete(Key.userId.rawValue)
    }
}
