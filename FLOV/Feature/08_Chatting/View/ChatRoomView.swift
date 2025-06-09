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
            messageListView()
            sendFieldView()
        }
        .onAppear {
            viewModel.action(.createChatRoom(viewModel.opponentId))
            viewModel.action(.loadChatRoomInfo(viewModel.opponentId))
        }
        .onDisappear {
            viewModel.action(.disconnectSocket)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                toolbarTitle()
            }
        }
    }
}

// MARK: - ChatListView
private extension ChatRoomView {
    func messageListView() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 8) {
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
                    .font(.Body.body1.weight(.medium))
                    .padding(.vertical, 9)
                    .padding(.horizontal, 12)
                    .background(.colDeep)
                    .foregroundStyle(.gray90)
                    .asRoundedBackground(cornerRadius: 16, strokeColor: .gray30)
                    .frame(maxWidth: 280, alignment: .trailing)
            } else {
                Text(message.content)
                    .font(.Body.body1.weight(.medium))
                    .padding(.vertical, 9)
                    .padding(.horizontal, 12)
                    .foregroundStyle(.gray90)
                    .asRoundedBackground(cornerRadius: 16, strokeColor: .gray30)
                    .frame(maxWidth: 280, alignment: .leading)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - ChatFieldView
private extension ChatRoomView {
    func sendFieldView() -> some View {
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

// MARK: - Toolbar
private extension ChatRoomView {
    func toolbarTitle() -> some View {
        Text(viewModel.output.opponentInfo?.nick ?? "CHATTING")
            .foregroundStyle(.colDeep)
            .font(.Caption.caption0)
            .lineLimit(1)
    }
}
