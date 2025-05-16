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
    
    var body: some View {
        
        NavigationStack(path: $pathModel.path) {
            TabView(selection: $selectedTab) {
                pathModel.build(.activity)
                    .asTabModifier(.activity)
                
                pathModel.build(.post)
                    .asTabModifier(.post)
                
                pathModel.build(.keep)
                    .asTabModifier(.keep)
                
                pathModel.build(.profile)
                    .asTabModifier(.profile)
            }
            .navigationDestination(for: Screen.self) { screen in
                pathModel.build(screen)
            }
            .fullScreenCover(item: $pathModel.fullScreenCover) { fullScreenCover in
                pathModel.build(fullScreenCover)
            }
        }
    }
}
