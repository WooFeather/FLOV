//
//  ActivitiView.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject private var pathModel: PathModel
    @State private var isSigned: Bool = false
    
    let userRepo = UserRepository.shared
    
    var body: some View {
        Button {
            if !UserDefaultsManager.isSigned {
                pathModel.presentFullScreenCover(.signIn)
            } else {
                Task {
                    do {
                        _ = try await userRepo.profileLookup()
                        isSigned = true                // 성공 시 true
                    } catch {
                        isSigned = false               // (refresh 실패 포함) 실패 시 false
                        UserDefaultsManager.isSigned = false
                        pathModel.presentFullScreenCover(.signIn) // 다시 로그인 화면으로
                    }
                }
            }
        } label: {
            Text("ActivityView")
        }
        .alert("로그인된 유저입니다.", isPresented: $isSigned) { }
    }
}

//#Preview {
//    ActivityView()
//        .injectDIContainer()
//}
