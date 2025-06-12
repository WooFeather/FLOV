//
//  ChatRoomView.swift
//  FLOV
//
//  Created by 조우현 on 6/3/25.
//

import SwiftUI

struct ChatRoomView: View {
    @EnvironmentObject var pathModel: PathModel
    @Environment(\.scenePhase) private var scenePhase
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
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                    viewModel.action(.reconnectSocket)
            case .inactive, .background:
                    viewModel.action(.disconnectSocket)
            @unknown default:
                break
            }
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
                LazyVStack(spacing: 12) {
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
        let isMyMessage = message.sender.id == UserSecurityManager.shared.userId
        return HStack(alignment: .top, spacing: 8) {
            if isMyMessage {
                Spacer()
                myBubble(message)
            } else {
                opponentBubble(message)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: isMyMessage ? .trailing : .leading)
        .padding(.horizontal)
    }
    
    func myBubble(_ message: ChatMessageEntity) -> some View {
        HStack(alignment: .bottom, spacing: 8) {
            Text(message.createdAt.toString(format: "a h:mm") ?? "")
                .font(.Caption.caption2.weight(.regular))
                .foregroundStyle(.gray60)
            
            Text(message.content)
                .font(.Body.body1.weight(.medium))
                .padding(.vertical, 9)
                .padding(.horizontal, 12)
                .background(.colDeep)
                .foregroundStyle(.gray90)
                .asRoundedBackground(cornerRadius: 16, strokeColor: .gray30)
        }
    }
    
    func opponentBubble(_ message: ChatMessageEntity) -> some View {
        HStack(alignment: .top, spacing: 8) {
            KFRemoteImageView(
                path: message.sender.profileImageURL ?? "",
                aspectRatio: 1,
                cachePolicy: .memoryAndDiskWithOriginal,
                height: 40
            )
            .clipShape(Circle())
            
            HStack(alignment: .bottom, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.sender.nick)
                        .font(.Caption.caption1.weight(.semibold))
                        .foregroundStyle(.gray60)
                    
                    Text(message.content)
                        .font(.Body.body1.weight(.medium))
                        .padding(.vertical, 9)
                        .padding(.horizontal, 12)
                        .foregroundStyle(.gray90)
                        .asRoundedBackground(cornerRadius: 16, strokeColor: .gray30)
                }
                
                Text(message.createdAt.toString(format: "a h:mm") ?? "")
                    .font(.Caption.caption2.weight(.regular))
                    .foregroundStyle(.gray60)
            }
        }
    }
}

// MARK: - ChatFieldView
private extension ChatRoomView {
    func sendFieldView() -> some View {
        VStack(spacing: 0) {
            Divider()
                .background(.gray45)
            
            // TODO: 텍스트필드 높이 동적 조절
            HStack(alignment: .bottom, spacing: 12) {
                TextEditor(text: $viewModel.output.chatText)
                    .font(.Body.body1.weight(.medium))
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .onChange(of: viewModel.output.chatText) { newValue in
                        viewModel.action(.updateChatText(newValue))
                    }
                    .offset(x: 10, y: 4)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.gray30)
                    )
                    .frame(height: 44)
                
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(viewModel.output.isSendButtonEnabled ? .colBlack : .gray)
                    .asButton {
                        viewModel.action(.sendMessage)
                    }
                    .disabled(!viewModel.output.isSendButtonEnabled)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.white)
        }
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
