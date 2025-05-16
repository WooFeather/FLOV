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
            EmailSignInView(viewModel: EmailSignInViewModel(userRepository: self.userRepository))
        case .signUp:
            SignUpView(viewModel: SignUpViewModel(userRepository: self.userRepository))
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
            SignInView(viewModel: SignInViewModel(userRepository: self.userRepository))
        case .postWrite:
            PostWriteView()
        }
    }
}
