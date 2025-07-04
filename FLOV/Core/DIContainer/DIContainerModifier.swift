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
        let authInterceptor = AuthInterceptor(tokenManager: UserSecurityManager.shared, authManager: authManager)
        let session = Session(interceptor: authInterceptor)
        let networkManager = NetworkManager(tokenManager: UserSecurityManager.shared, authManager: authManager, session: session)
        let authRepository = AuthRepository(networkManager: networkManager, tokenManager: UserSecurityManager.shared)
        let userRepository = UserRepository(networkManager: networkManager, authManager: authManager)
        let activityRepository = ActivityRepository(networkManager: networkManager)
        let chatRepository = ChatRepository(networkManager: networkManager)
        let chatService = ChatService(chatRepository: chatRepository)
        let orderRepository = OrderRepository(networkManager: networkManager)
        let paymentRepository = PaymentRepository(networkManager: networkManager)
        let postRepository = PostRepository(networkManager: networkManager)
        let locationService = LocationService()
        
        self.container = DIContainer(
            services: .init(
                networkManager: networkManager,
                userRepository: userRepository,
                authRepository: authRepository,
                activityRepository: activityRepository,
                authManager: authManager,
                chatRepository: chatRepository,
                chatService: chatService,
                orderRepository: orderRepository,
                paymentRepository: paymentRepository,
                postRepository: postRepository,
                locationService: locationService
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
