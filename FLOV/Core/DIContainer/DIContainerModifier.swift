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
        let networkManager = NetworkManager(tokenManager: TokenManager.shared)
        let authRepository = AuthRepository(networkManager: networkManager, tokenManager: TokenManager.shared)
        let userRepository = UserRepository(networkManager: networkManager, tokenManager: TokenManager.shared)
        let activityRepository = ActivityRepository(networkManager: networkManager)
        
        self.container = DIContainer(
            services: .init(
                networkManager: networkManager,
                userRepository: userRepository,
                authRepository: authRepository,
                activityRepository: activityRepository
            )
        )
    }
    
    func body(content: Content) -> some View {
        content
            .environmentObject(container.makePathModel())
    }
}

extension View {
    func injectDIContainer() -> some View {
        modifier(DIContainerModifier())
    }
}
