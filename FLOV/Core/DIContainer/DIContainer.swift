//
//  DIContainer.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import Foundation

final class DIContainer {
    let services: Services
    
    struct Services {
        let userRepository: UserRepositoryType
    }
    
    init(
        services: Services
    ) {
        self.services = services
    }
    
    /// Factory Method: PathModel 생성시 필요한 의존성을 자동 주입
    func makePathModel() -> PathModel {
        PathModel(container: self)
    }
}
