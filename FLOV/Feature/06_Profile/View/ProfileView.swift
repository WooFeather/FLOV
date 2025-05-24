//
//  ProfileView.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
//    @StateObject var viewModel: ProfileViewModel
    
    var body: some View {
        ZStack {
//            if viewModel.output.isLoading {
//                ProgressView()
//            }
            
            VStack {
                Button("로그아웃") {
                    authManager.signOut()
                }
                
                Text("ProfileView")
//                Button("프로필 조회") {
//                    viewModel.action(.fetchProfile)
//                }
//                
//                Text(viewModel.output.profile?.user_id ?? "아이디없음")
//                Text(viewModel.output.profile?.email ?? "이메일없음")
//                Text(viewModel.output.profile?.nick ?? "닉네임없음")
            }
        }
//        .onAppear {
//            viewModel.action(.fetchProfile)
//        }
//        .alert("로그인이 만료되었습니다.", isPresented: $viewModel.output.showSessionExpiredAlert) {
//            Button("로그인") {
//                viewModel.pathModel.presentFullScreenCover(.signIn)
//            }
//            Button("취소", role: .cancel) {}
//        } message: {
//            Text("다시 로그인해주세요.")
//        }
    }
}

//#Preview {
//    ProfileView()
//}
