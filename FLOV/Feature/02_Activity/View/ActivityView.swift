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
        VStack {
            Text(authManager.isSigned ? "로그인됨" : "로그인 안됨")
            
            List(viewModel.output.newActivities, id: \.id) { data in
                Text(data.title)
            }
        }
        .onAppear {
            print("ActivityView.onAppear")
            // 뷰가 보여질때 로그인 여부 확인 후 로그인 돼있다면 newActivity 목록조회 API 호출
            // 로그인이 안돼있다면 pathModel을 통해 SignInView 띄우기
            if authManager.isSigned {
                viewModel.action(.fetchAllActivities)
            } else {
                pathModel.presentFullScreenCover(.signIn)
            }
        }
        .onChange(of: authManager.isSigned) { signed in
            if signed {
                viewModel.action(.fetchAllActivities)
            }
        }
    }
}

//#Preview {
//    ActivityView()
//        .injectDIContainer()
//}
