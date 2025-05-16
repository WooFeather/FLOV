//
//  PathModel.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI

protocol PathModelType: ObservableObject {
    var path: NavigationPath { get set }
    var fullScreenCover: FullScreenCover? { get set }
    
    func push(_ screen: Screen)
    func presentFullScreenCover(_ cover: FullScreenCover)
    func pop()
    func popToRoot()
    func dismissFullScreenCover()
}

final class PathModel: PathModelType {
    
    let container: DIContainer
    
    @Published var path: NavigationPath = NavigationPath()
    @Published var fullScreenCover: FullScreenCover?
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func presentFullScreenCover(_ cover: FullScreenCover) {
        self.fullScreenCover = cover
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissFullScreenCover() {
        self.fullScreenCover = nil
    }
}
