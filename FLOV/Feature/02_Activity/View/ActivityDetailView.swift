//
//  ActivitiDetailView.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI

struct ActivityDetailView: View {
    @EnvironmentObject var pathModel: PathModel
    @StateObject var viewModel: ActivityDetailViewModel
    
    var body: some View {
        Text(viewModel.output.activityDetails?.summary.title ?? "ActivityDetailView")
    }
}
