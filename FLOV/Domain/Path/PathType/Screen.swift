//
//  Screen.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import Foundation

enum Screen: Identifiable, Hashable {
    
    // 01_Register
    case signIn
    case emailSignIn
    case signUp
    
    // 02_Activity
    case activity
    case activityDetail(id: String)
    
    // 03_Post
    case post
    case postDetail
    
    // 04_Search
    case search
    
    // 05_Keep
    case keep
    
    // 06_Profile
    case profile
    case profileEdit // 그냥 profileView에서 수정가능하게 할지 고민
    
    // 07_Notification
    case notification
    
    var id: Self { self }
}
