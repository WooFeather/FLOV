//
//  KeychainManager.swift
//  FLOV
//
//  Created by 조우현 on 5/14/25.
//

import Foundation
import Security

final class KeychainManager {
    static let shared = KeychainManager()
    private init() {}
    
    func save(_ value: String, forKey key: String) {
        guard let data = value.data(using: .utf8) else { return }
        let query: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecValueData as String : data
        ]
        SecItemDelete(query as CFDictionary) // 기존 항목 삭제
        SecItemAdd(query as CFDictionary, nil) // 새 항목 추가
    }
    
    func read(_ key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String : kCFBooleanTrue!,
            kSecMatchLimit as String : kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess,
              let data = item as? Data,
              let str = String(data: data, encoding: .utf8)
        else { return nil }
        return str
    }
    
    func delete(_ key: String) {
        let query: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
