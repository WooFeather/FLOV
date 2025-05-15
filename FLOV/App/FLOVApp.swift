//
//  FLOVApp.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKCommon

@main
struct FLOVApp: App {
    init() {
        /// KakaoSDK 초기화
        KakaoSDK.initSDK(appKey: Config.kakaoNativeAppKey) // TODO: DIContainer 적용
    }
    
    var body: some Scene {
        WindowGroup {
            SignUpView(viewModel: SignUpViewModel(userRepository: UserRepository.shared))
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
