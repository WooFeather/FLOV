//
//  DIContainerModifier.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI

struct DIContainerModifier: ViewModifier {
    private let container = DIContainer(
        services: .init(userRepository: UserRepository.shared)
    )
    
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
