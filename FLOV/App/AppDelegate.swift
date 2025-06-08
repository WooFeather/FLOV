//
//  AppDelegate.swift
//  FLOV
//
//  Created by 조우현 on 6/8/25.
//

import UIKit
import UserNotifications
import Alamofire
import Firebase
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // 알림 권한 요청
        UNUserNotificationCenter.current().delegate = self
        
        let authOpts: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOpts) { granted, error in
            // 권한 처리
        }
        
        // APNs 등록 요청
        application.registerForRemoteNotifications()
        
        // FCM 델리게이트 설정
        Messaging.messaging().delegate = self
        
        // 현재 토큰 정보 가져오기: 로그아웃, 로그인 등에서 사용
        Messaging.messaging().token { token, error in
            print("FCM token:", token ?? "nil", error as Any)
        }
        
        return true
    }
    
    // APNs deviceToken 수신
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // APNs 토큰을 FCM에 연결
         Messaging.messaging().apnsToken = deviceToken
    }
    
    // APNs 등록 실패
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs 등록 실패:", error)
    }
}

// TODO: 로그아웃시 토큰 초기화 및 로그인시 재발급
extension AppDelegate: MessagingDelegate {
    // FCM 등록 토큰 수신
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("🔑 New FCM token:", fcmToken)
        
        TokenManager.shared.fcmToken = fcmToken
        
        guard TokenManager.shared.accessToken != nil else { return }
        
        Task {
          try await UserRepository(
                networkManager: NetworkManager(
                    tokenManager: TokenManager.shared,
                    authManager: AuthManager(),
                    session: Session()
                ),
                authManager: AuthManager()
            )
          .deviceTokenUpdate(request: .init(deviceToken: fcmToken))
        }
    }
}
