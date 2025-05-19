//
//  UserDefaultsManager.swift
//  FLOV
//
//  Created by 조우현 on 5/17/25.
//

import Foundation

@propertyWrapper
struct FlovUserDefaults<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

enum UserDefaultsManager {
    enum Key: String {
        case isSigned
    }
    
    @FlovUserDefaults(key: Key.isSigned.rawValue, defaultValue: false)
    static var isSigned
}
