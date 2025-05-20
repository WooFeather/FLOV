//
//  PathModelBuilder.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI

extension PathModel {
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .activity:
            ActivityView(activityRepo: container.services.activityRepository)
        case .activityDetail:
            ActivityDetailView()
        case .post:
            PostView()
        case .postDetail:
            PostDetailView()
        case .search:
            SearchView()
        case .keep:
            KeepView()
        case .profile:
//            let vm = ProfileViewModel(userRepository: container.services.userRepos)
            ProfileView()
        case .profileEdit:
            ProfileEditView()
        }
    }
        
    @ViewBuilder
    func build(_ fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .signIn:
            let vm = SignInViewModel(userRepository: container.services.userRepository)
            SignInView(viewModel: vm)
        case .emailSignIn:
            let vm = EmailSignInViewModel(userRepository: container.services.userRepository)
            EmailSignInView(viewModel: vm)
        case .signUp:
            let vm = SignUpViewModel(userRepository: container.services.userRepository)
            SignUpView(viewModel: vm)
        case .postWrite:
            PostWriteView()
        }
    }
}
