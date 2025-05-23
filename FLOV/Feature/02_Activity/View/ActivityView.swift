//
//  ActivityView.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject private var pathModel: PathModel
    @AppStorage("isSigned") private var isSigned: Bool = false

    let activityRepo: ActivityRepositoryType
    @State private var list: [ActivitySummaryEntity] = []

    var body: some View {
        VStack {
            Button {
                if !isSigned {
                    pathModel.presentFullScreenCover(.signIn)
                } else {
                    Task {
                        do {
                            let response = try await activityRepo.listLookup(country: nil, category: nil, limit: nil, next: nil)
                            
                            list = response.data
                        } catch {
                            print(error)
                        }
                    }
                }
            } label: {
                Text("TEST")
            }

            List(list, id: \.id) { data in
                Text(data.title)
            }
        }
    }
}

//#Preview {
//    ActivityView()
//        .injectDIContainer()
//}
