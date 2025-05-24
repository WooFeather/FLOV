//
//  AppCoordinatorView.swift
//  FLOV
//
//  Created by 조우현 on 5/23/25.
//

import SwiftUI

struct AppCoordinatorView: View {
    @EnvironmentObject private var authManager: AuthManager
    
    var body: some View {
        if authManager.isSigned {
            FlovTabView()
        } else {
            RegisterView()
        }
    }
}

//#Preview {
//    AppCoordinatorView()
//}
