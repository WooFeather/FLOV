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

class AppDelegate: NSObject, UIApplicationDelegate {
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

extension AppDelegate: MessagingDelegate {
    // FCM 등록 토큰 수신
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("🔑 New FCM token:", fcmToken)
        
        UserSecurityManager.shared.fcmToken = fcmToken
        
        guard UserSecurityManager.shared.accessToken != nil else { return }
        
        Task {
          try await UserRepository(
                networkManager: NetworkManager(
                    tokenManager: UserSecurityManager.shared,
                    authManager: AuthManager(),
                    session: Session()
                ),
                authManager: AuthManager()
            )
          .deviceTokenUpdate(request: .init(deviceToken: fcmToken))
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 포그라운드에서 Alert 띄워줄지 여부
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification)
        print(notification.request.content.title)
        print(notification.request.content.userInfo)
        
        // TODO: 대화중인 채팅방에서는 포그라운드 알림을 받지 않기 -> 어떤 값으로 분기처리할지 추후에 처리
        // guard let user = notification.request.content.userInfo["user"] as? String else { return }
        
        completionHandler([.list, .banner, .badge, .sound])
    }
    
    // 푸시 탭했을 때 특정 화면으로 이동
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification)
        print(response.notification.request.content.title)
        print(response.notification.request.content.userInfo)
        
        // TODO: 푸시를 탭했을 때 유저 ID에 대응하여 채팅방으로 이동
        // guard let user = response.notification.request.content.userInfo["user"] as? String else { return }
    }
}
