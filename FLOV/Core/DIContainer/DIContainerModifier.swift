//
//  DIContainerModifier.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI
import Alamofire

struct DIContainerModifier: ViewModifier {
    private let container: DIContainer
    
    init() {
        let authManager = AuthManager()
        let authInterceptor = AuthInterceptor(tokenManager: TokenManager.shared, authManager: authManager)
        let session = Session(interceptor: authInterceptor)
        let networkManager = NetworkManager(tokenManager: TokenManager.shared, authManager: authManager, session: session)
        let authRepository = AuthRepository(networkManager: networkManager, tokenManager: TokenManager.shared)
        let userRepository = UserRepository(networkManager: networkManager, authManager: authManager)
        let activityRepository = ActivityRepository(networkManager: networkManager)
        let chatRepository = ChatRepository(networkManager: networkManager)
        let chatService = ChatService(chatRepository: chatRepository)
        
        self.container = DIContainer(
            services: .init(
                networkManager: networkManager,
                userRepository: userRepository,
                authRepository: authRepository,
                activityRepository: activityRepository,
                authManager: authManager,
                chatRepository: chatRepository,
                chatService: chatService
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
