//
//  ActivityView.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var pathModel: PathModel
    @StateObject var viewModel: ActivityViewModel

    var body: some View {
        ScrollView {
            VStack {
                Text("ActivityView")
            }
        }
        .asNavigationToolbar()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                logoImage()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                alertButton()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                searchButton()
            }
        }
        .onAppear {
            viewModel.action(.fetchAllActivities)
        }
    }
}

// MARK: - Toolbar
private extension ActivityView {
    func logoImage() -> some View {
        Image(.flovLogo)
            .resizable()
            .frame(width: 80, height: 24)
    }
    
    func alertButton() -> some View {
        Image(.icnNoti)
            .resizable()
            .frame(width: 32, height: 32)
            .asButton {
                pathModel.push(.notification)
            }
    }
    
    func searchButton() -> some View {
        Image(.icnSearch)
            .resizable()
            .frame(width: 32, height: 32)
            .asButton {
                pathModel.push(.search)
            }
    }
}
