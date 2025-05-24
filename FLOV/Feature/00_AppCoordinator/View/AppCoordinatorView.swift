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
        if authManager.isSigned {
            FlovTabView()
        } else {
            RegisterView()
        }
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
        NavigationStack(path: $pathModel.path) {
            ZStack {
                TabView(selection: $selectedTab) {
                    pathModel.build(.activity)
                        .tag(FlovTab.activity)
                    
                    pathModel.build(.post)
                        .tag(FlovTab.post)
                    
                    pathModel.build(.keep)
                        .tag(FlovTab.keep)
                    
                    pathModel.build(.profile)
                        .tag(FlovTab.profile)
                }
                
                /// 커스텀 탭바
                VStack {
                    Spacer()
                    CustomTabBar(selectedTab: $selectedTab)
                }
            }
            .ignoresSafeArea()
            .navigationDestination(for: Screen.self) { screen in
                pathModel.build(screen)
            }
            .fullScreenCover(item: $pathModel.fullScreenCover) { cover in
                pathModel.build(cover)
            }
        }
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

//#Preview {
//    AppCoordinatorView()
//}
