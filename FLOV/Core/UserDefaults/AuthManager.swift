//
//  AuthManager.swift
//  FLOV
//
//  Created by 조우현 on 5/23/25.
//

import Foundation
import Combine

final class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published private(set) var isSigned: Bool
    private var cancellable: AnyCancellable?
    
    private init() {
        self.isSigned = UserDefaultsManager.isSigned
        
        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .sink { [weak self] _ in
                self?.isSigned = UserDefaultsManager.isSigned
            }
    }
}
