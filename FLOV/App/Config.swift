//
//  Config.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

enum Config {
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
            static let sesacKey = "SESAC_KEY"
            static let kakaoNativeAppKey = "KAKAO_NATIVE_APP_KEY"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist 찾지 못함")
        }
        return dict
    }()
}

extension Config {
    static let baseURL: String = {
        guard let url = Config.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("Config.baseURL 오류")
        }
        return url
    }()
    
    static let sesacKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.sesacKey] as? String else {
            fatalError("Config.sesacKey 오류")
        }
        return key
    }()
    
    static let kakaoNativeAppKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.kakaoNativeAppKey] as? String else {
            fatalError("Config.kakaoNativeAppKey 오류")
        }
        return key
    }()
}
