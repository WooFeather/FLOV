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
        case .signIn:
            let vm = SignInViewModel(userRepository: container.services.userRepository)
            SignInView(viewModel: vm)
        case .emailSignIn:
            let vm = EmailSignInViewModel(userRepository: container.services.userRepository)
            EmailSignInView(viewModel: vm)
        case .signUp:
            let vm = SignUpViewModel(userRepository: container.services.userRepository)
            SignUpView(viewModel: vm)
        case .activity:
            let vm = ActivityViewModel(activityRepository: container.services.activityRepository)
            ActivityView(viewModel: vm)
        case .activityDetail(let id):
            let vm = ActivityDetailViewModel(activityRepository: container.services.activityRepository, orderRepository: container.services.orderRepository, paymentRepository: container.services.paymentRepository, activityId: id)
            ActivityDetailView(viewModel: vm)
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
        case .notification:
            NotificationView()
        case .recentNoti:
            RecentNotiView()
        case .chatList:
            let vm = ChatListViewModel(chatRepository: container.services.chatRepository)
            ChatListView(viewModel: vm)
        case .chatRoom(let id):
            let vm = ChatRoomViewModel(
                chatService: container.services.chatService,
                opponentId: id
            )
            ChatRoomView(viewModel: vm)
        }
    }
        
    @ViewBuilder
    func build(_ fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .payment(let name, let price, let orderCode):
            PaymentFullScreen(name: name, price: price, orderCode: orderCode)
        case .postWrite:
            PostWriteView()
        }
    }
}
