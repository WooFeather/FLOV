//
//  ActivitiView.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    var body: some View {
        Button {
            pathModel.presentFullScreenCover(.signIn)
        } label: {
            Text("ActivityView")
        }
    }
}

#Preview {
    ActivityView()
        .injectDIContainer()
}
