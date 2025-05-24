//
//  AppCoordinatorView.swift
//  FLOV
//
//  Created by 조우현 on 5/23/25.
//

import SwiftUI

struct AppCoordinatorView: View {
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var pathModel: PathModel
    
    var body: some View {
        if authManager.isSigned {
            FlovTabView()
                .environmentObject(pathModel)
        } else {
            SignInView(
                viewModel: SignInViewModel(
                    userRepository: pathModel.container.services.userRepository
                )
            )
            .environmentObject(pathModel)
        }
    }
}

//#Preview {
//    AppCoordinatorView()
//}
