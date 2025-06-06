//
//  ChatRepository.swift
//  FLOV
//
//  Created by 조우현 on 6/4/25.
//

import Foundation
import Alamofire

protocol ChatRepositoryType {
    func createChat(request: CreateChatRequest) async throws -> ChatRoomEntity
    func chatListLookup() async throws -> [ChatRoomEntity]
    func sendMessage(roomId: String, request: SendMessageRequest) async throws -> ChatMessageEntity
    func messageListLookup(roomId: String, next: String?) async throws -> [ChatRoomEntity]
    func uploadFiles(roomId: String, fileDatas: [Data]) async throws -> UploadFilesEntity
}

final class ChatRepository: ChatRepositoryType {
    private let networkManager: NetworkManagerType

    init(networkManager: NetworkManagerType) {
        self.networkManager = networkManager
    }
    
    func createChat(request: CreateChatRequest) async throws -> ChatRoomEntity {
        let response: ChatRoomResponse = try await networkManager.callRequest(ChatAPI.createChat(request: request))
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func chatListLookup() async throws -> [ChatRoomEntity] {
        let response: ListLookupResponse = try await networkManager.callRequest(ChatAPI.chatListLookup)
        
        let entity = response.data.map { $0.toEntity() }
        
        return entity
    }
    
    func sendMessage(roomId: String, request: SendMessageRequest) async throws -> ChatMessageEntity {
        let response: ChatMessage = try await networkManager.callRequest(ChatAPI.sendMessage(roomId: roomId, request: request))
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func messageListLookup(roomId: String, next: String?) async throws -> [ChatRoomEntity] {
        let response: ListLookupResponse = try await networkManager.callRequest(ChatAPI.messageListLookup(roomId: roomId, next: next))
        
        let entity = response.data.map { $0.toEntity() }
        
        return entity
    }
    
    func uploadFiles(roomId: String, fileDatas: [Data]) async throws -> UploadFilesEntity {
        let response: UploadFilesResponse = try await networkManager.uploadMultipart(ChatAPI.uploadFiles(roomId: roomId)) { form in
            for data in fileDatas {
                form.append(
                    data,
                    withName: "chatFiles",
                    fileName: "upload.png",
                    mimeType: "image/png"
                )
            }
        }
        
        let entity = response.toEntity()
        
        return entity
    }
}
