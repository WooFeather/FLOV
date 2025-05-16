//
//  Tab.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI

enum FlovTab: Identifiable, CaseIterable {
    case activity
    case post
    case keep
    case profile
    
    var id: UUID {
        return .init()
    }
    
    var icon: Image {
        switch self {
        case .activity:
            return Image(.tabBarHomeFill)
        case .post:
            return Image(.tabBarPostFill)
        case .keep:
            return Image(.tabBarKeepFill)
        case .profile:
            return Image(.tabBarProfileFill)
        }
    }
}
