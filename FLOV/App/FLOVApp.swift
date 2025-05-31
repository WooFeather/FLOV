//
//  FLOVApp.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKCommon
import Kingfisher

@main
struct FLOVApp: App {
    init() {
        /// KakaoSDK 초기화
        KakaoSDK.initSDK(appKey: Config.kakaoNativeAppKey)
        KingfisherConfig()
    }
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
                .injectDIContainer()
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}

private func KingfisherConfig() {
    let cache = KingfisherManager.shared.cache
    cache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
    cache.diskStorage.config.sizeLimit = 200 * 1024 * 1024
    cache.diskStorage.config.expiration = .days(7)
}
