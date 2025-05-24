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
        VStack {
            List(viewModel.output.newActivities, id: \.id) { activity in
                Text(activity.title)
            }
            .listStyle(PlainListStyle())
        }
        .onAppear {
            viewModel.action(.fetchAllActivities)
        }
    }
}

//#Preview {
//    ActivityView()
//        .injectDIContainer()
//}
