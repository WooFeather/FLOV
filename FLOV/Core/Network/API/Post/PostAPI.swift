//
//  PostAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/21/25.
//

import Foundation
import Alamofire

enum PostAPI {
    case fileUpload
    case postWrite(request: PostWriteRequest)
    case postLookup(country: String?, category: String?, longitude: Double?, latitude: Double?, maxDistance: String?, limit: Int?, next: String?, orderBy: String?)
    case postSearch(title: String?)
    case postDetailLookup(postId: String)
    case postModification(postId: String, request: PostModificationRequest)
    case postDelete(postId: String)
    case postLike(postId: String, request: PostLikeRequest)
    case userPostLookup(country: String?, category: String?, limit: Int?, next: String?, userId: String)
    case likePostLookup(country: String?, category: String?, next: String?, limit: Int?)
}

extension PostAPI: Router {
    var path: String {
        switch self {
        case .fileUpload:
            return "/v1/posts/files"
        case .postWrite:
            return "/v1/posts"
        case .postLookup:
            return "/v1/posts/geolocation"
        case .postSearch:
            return "/v1/posts/search"
        case .postDetailLookup(let postId),
                .postModification(let postId, _),
                .postDelete(let postId):
            return "/v1/posts/\(postId)"
        case .postLike(let postId, _):
            return "/v1/posts/\(postId)/like"
        case .userPostLookup(_, _, _, _, let userId):
            return "/v1/posts/users/\(userId)"
        case .likePostLookup:
            return "/v1/posts/likes/me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fileUpload, .postWrite, .postLike:
            return .post
        case .postLookup, .postSearch, .postDetailLookup, .userPostLookup, .likePostLookup:
            return .get
        case .postModification:
            return .put
        case .postDelete:
            return .delete
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .fileUpload:
            return [
                "Authorization": UserSecurityManager.shared.accessToken ?? "",
                "SeSACKey": Config.sesacKey,
                "Content-Type": "multipart/form-data"
            ]
        case .postWrite, .postModification, .postLike:
            return [
                "Authorization": UserSecurityManager.shared.accessToken ?? "",
                "SeSACKey": Config.sesacKey,
                "Content-Type": "application/json"
            ]
        case .postLookup, .postSearch, .postDetailLookup, .postDelete, .userPostLookup, .likePostLookup:
            return [
                "Authorization": UserSecurityManager.shared.accessToken ?? "",
                "SeSACKey": Config.sesacKey
            ]
        }
    }
    
    var params: Parameters {
        switch self {
        case .fileUpload, .postWrite:
            return [:]
        case .postLookup(let country, let category, let longitude, let latitude, let maxDistance, let limit, let next, let orderBy):
            var parameters: Parameters = [:]
            if let country = country { parameters["country"] = country }
            if let category = category { parameters["category"] = category }
            if let longitude = longitude { parameters["longitude"] = longitude }
            if let latitude = latitude { parameters["latitude"] = latitude }
            if let maxDistance = maxDistance { parameters["maxDistance"] = maxDistance }
            if let limit = limit { parameters["limit"] = limit }
            if let next = next { parameters["next"] = next }
            if let orderBy = orderBy { parameters["order_by"] = orderBy }
            return parameters
        case .postSearch(let title):
            var parameters: Parameters = [:]
            if let title = title { parameters["title"] = title }
            return parameters
        case .postDetailLookup(let postId), .postModification(let postId, _), .postDelete(let postId), .postLike(let postId, _):
            return ["post_id": postId]
        case .userPostLookup(let country, let category, let limit, let next, let userId):
            var parameters: Parameters = [:]
            if let country = country { parameters["country"] = country }
            if let category = category { parameters["category"] = category }
            if let limit = limit { parameters["limit"] = limit }
            if let next = next { parameters["next"] = next }
            parameters["user_id"] = userId
            return parameters
        case .likePostLookup(let country, let category, let next, let limit):
            var parameters: Parameters = [:]
            if let country = country { parameters["country"] = country }
            if let category = category { parameters["category"] = category }
            if let next = next { parameters["next"] = next }
            if let limit = limit { parameters["limit"] = limit }
            return parameters
        }
    }
    
    var requestBody: Encodable? {
        switch self {
        case .fileUpload:
            return nil
        case .postWrite(let request):
            return request
        case .postLookup:
            return nil
        case .postSearch:
            return nil
        case .postDetailLookup:
            return nil
        case .postModification(_, let request):
            return request
        case .postDelete:
            return nil
        case .postLike(_, let request):
            return request
        case .userPostLookup:
            return nil
        case .likePostLookup:
            return nil
        }
    }
}
