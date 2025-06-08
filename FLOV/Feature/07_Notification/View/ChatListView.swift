//
//  ChatListView.swift
//  FLOV
//
//  Created by 조우현 on 6/8/25.
//

import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var pathModel: PathModel
    @StateObject var viewModel: ChatListViewModel
    
    var body: some View {
        ScrollView {
            if viewModel.output.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ForEach(viewModel.output.chatList, id: \.roomId) { chatRoom in
                    chatRoomRow(chatRoom)
                }
            }
        }
        .onAppear {
            viewModel.action(.fetchChatList)
        }
    }
}

extension ChatListView {
    func chatRoomRow(_ chatRoom: ChatRoomEntity) -> some View {
        let currentUserId = UserSecurityManager.shared.userId
        
        // 상대방중 나의 id와 다른 사람을 찾고, 그게 아니라면 나와의 채팅
        let opponent = chatRoom.participants
            .first { $0.id != currentUserId }
            ?? chatRoom.participants.first { $0.id == currentUserId }
            ?? chatRoom.participants.first!
        
        return HStack {
            KFRemoteImageView(
                path: opponent.profileImageURL ?? "",
                aspectRatio: 1,
                cachePolicy: .memoryAndDiskWithOriginal,
                height: 42
            )
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(opponent.id == currentUserId ? "나와의 채팅" : opponent.nick)
                    .font(.Body.body1.bold())
                    .foregroundStyle(.colBlack)
                
                Text(chatRoom.lastChat?.content ?? "")
                    .font(.Caption.caption1)
                    .foregroundStyle(.accent)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .contentShape(Rectangle())
        .onTapGesture {
            pathModel.push(.chatRoom(id: opponent.id))
        }
    }
}
