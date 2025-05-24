//
//  ActivityView.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var pathModel: PathModel
    @EnvironmentObject var authManager: AuthManager
    @StateObject var viewModel: ActivityViewModel

    var body: some View {
        List(viewModel.output.newActivities, id: \.id) { activity in
            Text(activity.title)
        }
        .listStyle(PlainListStyle())
        .onAppear {
            guard authManager.isSigned else { return }
            viewModel.action(.fetchAllActivities)
        }
    }
}

//#Preview {
//    ActivityView()
//        .injectDIContainer()
//}
