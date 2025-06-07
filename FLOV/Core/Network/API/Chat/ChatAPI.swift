//
//  ChatAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/4/25.
//

import Foundation
import Alamofire

enum ChatAPI {
    case createChat(request: CreateChatRequest)
    case chatListLookup
    case sendMessage(roomId: String, request: SendMessageRequest)
    case messageListLookup(roomId: String, next: String?)
    case uploadFiles(roomId: String)
}

extension ChatAPI: Router {
    var path: String {
        switch self {
        case .createChat, .chatListLookup:
            return "/v1/chats"
        case .sendMessage(let roomId, _), .messageListLookup(let roomId, _):
            return "/v1/chats/\(roomId)"
        case .uploadFiles(let roomId):
            return "/v1/chats/\(roomId)/files"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createChat, .sendMessage, .uploadFiles:
            return .post
        case .chatListLookup, .messageListLookup:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .createChat, .sendMessage:
            return [
                "Authorization": TokenManager.shared.accessToken ?? "",
                "SeSACKey": Config.sesacKey,
                "Content-Type": "application/json"
            ]
        case .chatListLookup, .messageListLookup:
            return [
                "Authorization": TokenManager.shared.accessToken ?? "",
                "SeSACKey": Config.sesacKey
            ]
        case .uploadFiles:
            return [
                "Authorization": TokenManager.shared.accessToken ?? "",
                "SeSACKey": Config.sesacKey,
                "Content-Type": "multipart/form-data"
            ]
        }
    }
    
    var params: Parameters {
        switch self {
        case .sendMessage(let roomId, _), .uploadFiles(let roomId):
            return ["room_id": roomId]
        case .messageListLookup(let roomId, let next):
            var parameters: Parameters = ["room_id": roomId]
            if let next = next { parameters["next"] = next }
            return parameters
        case .createChat, .chatListLookup:
            return [:]
        }
    }
    
    var requestBody: Encodable? {
        switch self {
        case .createChat(let request):
            return request
        case .chatListLookup:
            return nil
        case .sendMessage(_, let request):
            return request
        case .messageListLookup:
            return nil
        case .uploadFiles:
            return nil
        }
    }
}
