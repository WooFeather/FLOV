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
        ScrollView {
            LazyVStack {
                ForEach(viewModel.output.messages, id: \.chatId) { message in
                    messageRowView(message)
                }
            }
        }
    }
    
    func messageRowView(_ message: ChatMessageEntity) -> some View {
        HStack {
            // TODO: userId에 따라 위치 변경
            Text(message.content)
                .padding()
                .background(.colDeep)
                .foregroundStyle(.gray90)
                .asRoundedBackground(cornerRadius: 12, strokeColor: .gray30)
        }
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
