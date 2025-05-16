//
//  FullScreenCover.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import Foundation

enum FullScreenCover: Identifiable, Hashable {
    
    // 01_Register
    case signIn
    case emailSignIn
    case signUp
    
    // 03_Post
    case postWrite
    
    var id: Self { self }
}
