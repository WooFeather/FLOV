//
//  ChatRoomView.swift
//  FLOV
//
//  Created by 조우현 on 6/3/25.
//

import SwiftUI

struct ChatRoomView: View {
    @EnvironmentObject var pathModel: PathModel
    @StateObject var viewModel: ChatRoomViewModel
    
    var body: some View {
        VStack {
            chatListView()
            chatFieldView()
        }
        .onAppear {
            viewModel.action(.createChatRoom(viewModel.opponentId))
        }
        .onDisappear {
            viewModel.action(.disconnectSocket)
        }
    }
}

// MARK: - ChatListView
private extension ChatRoomView {
    func chatListView() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.output.messages, id: \.chatId) { message in
                        messageRowView(message)
                            .id(message.chatId)
                    }
                }
            }
            .onChange(of: viewModel.output.messages.count) { _ in
                // 메시지 개수가 변경되면 자동 스크롤
                if let lastMessage = viewModel.output.messages.last {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        proxy.scrollTo(lastMessage.chatId, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    func messageRowView(_ message: ChatMessageEntity) -> some View {
        HStack {
            if message.sender.id == UserSecurityManager.shared.userId {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(.colDeep)
                    .foregroundStyle(.gray90)
                    .asRoundedBackground(cornerRadius: 12, strokeColor: .gray30)
            } else {
                Text(message.content)
                    .padding()
                    .foregroundStyle(.gray90)
                    .asRoundedBackground(cornerRadius: 12, strokeColor: .gray30)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - ChatFieldView
private extension ChatRoomView {
    func chatFieldView() -> some View {
        HStack {
            TextField("메시지 입력", text: $viewModel.output.chatText)
                .textFieldStyle(.roundedBorder)
            
            Text("전송")
                .asButton {
                    viewModel.action(.sendMessage)
                }
        }
        .padding()
    }
}
