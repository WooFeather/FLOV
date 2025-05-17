//
//  TabView.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI

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
                NavigationStack(path: $pathModel.coverNavigationPath) {
                    pathModel.build(cover)
                        .navigationDestination(for: FullScreenCover.self) { cover in
                            pathModel.build(cover)
                        }
                }
            }
        }
    }
}
