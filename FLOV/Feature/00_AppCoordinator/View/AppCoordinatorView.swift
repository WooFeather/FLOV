//
//  AppCoordinatorView.swift
//  FLOV
//
//  Created by 조우현 on 5/23/25.
//

import SwiftUI

// MARK: - AppCoordinatorView
struct AppCoordinatorView: View {
    @EnvironmentObject private var authManager: AuthManager
    
    var body: some View {
        Group {
            if authManager.isSigned {
                FlovTabView()
            } else {
                RegisterView()
            }
        }
        .animation(.easeInOut, value: authManager.isSigned)
    }
}

// MARK: - FlovTabView
struct FlovTabView: View {
    @EnvironmentObject var pathModel: PathModel
    @State private var selectedTab: FlovTab = .activity
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                NavigationStack(path: $pathModel.path) {
                    pathModel.build(.activity)
                        .navigationDestination(for: Screen.self) { screen in
                            pathModel.build(screen)
                        }
                }
                .tag(FlovTab.activity)
                
                NavigationStack(path: $pathModel.path) {
                    pathModel.build(.post)
                        .navigationDestination(for: Screen.self) { screen in
                            pathModel.build(screen)
                        }
                }
                .tag(FlovTab.post)
                
                NavigationStack(path: $pathModel.path) {
                    pathModel.build(.keep)
                        .navigationDestination(for: Screen.self) { screen in
                            pathModel.build(screen)
                        }
                }
                .tag(FlovTab.keep)
                
                NavigationStack(path: $pathModel.path) {
                    pathModel.build(.profile)
                        .navigationDestination(for: Screen.self) { screen in
                            pathModel.build(screen)
                        }
                }
                .tag(FlovTab.profile)
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - RegisterView
struct RegisterView: View {
    @EnvironmentObject var pathModel: PathModel
    
    var body: some View {
        NavigationStack(path: $pathModel.path) {
            pathModel.build(.signIn)
                .navigationDestination(for: Screen.self) { screen in
                    pathModel.build(screen)
                }
        }
    }
}
