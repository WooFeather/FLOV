//
//  DIContainerModifier.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI

struct DIContainerModifier: ViewModifier {
    private let container: DIContainer
    
    init() {
        let authManager = AuthManager()
        let networkManager = NetworkManager(tokenManager: TokenManager.shared, authManager: authManager)
        let authRepository = AuthRepository(networkManager: networkManager, tokenManager: TokenManager.shared)
        let userRepository = UserRepository(networkManager: networkManager, authManager: authManager)
        let activityRepository = ActivityRepository(networkManager: networkManager)
        
        self.container = DIContainer(
            services: .init(
                networkManager: networkManager,
                userRepository: userRepository,
                authRepository: authRepository,
                activityRepository: activityRepository,
                authManager: authManager
            )
        )
    }
    
    func body(content: Content) -> some View {
        content
            .environmentObject(container.makePathModel())
            .environmentObject(container.services.authManager)
    }
}

extension View {
    func injectDIContainer() -> some View {
        modifier(DIContainerModifier())
    }
}
