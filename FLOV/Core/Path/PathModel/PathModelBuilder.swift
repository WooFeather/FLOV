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
        case .emailSignIn:
            let vm = EmailSignInViewModel(userRepository: container.userRepository)
            EmailSignInView(viewModel: vm)
        case .signUp:
            let vm = SignUpViewModel(userRepository: container.userRepository)
            SignUpView(viewModel: vm)
        case .activity:
            ActivityView()
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
            ProfileView()
        case .profileEdit:
            ProfileEditView()
        }
    }
        
    @ViewBuilder
    func build(_ fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .signIn:
            let vm = SignInViewModel(userRepository: container.userRepository)
            SignInView(viewModel: vm)
        case .postWrite:
            PostWriteView()
        }
    }
}
