//
//  DIContainer.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import Foundation

final class DIContainer {
    let userRepository: UserRepositoryType
    
    init(
        userRepository: UserRepositoryType = UserRepository.shared
    ) {
        self.userRepository = userRepository
    }
    
    func makePathModel() -> PathModel {
        PathModel(container: self)
    }
}
