//
//  ActivityAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/19/25.
//

import Foundation
import Alamofire

enum ActivityAPI {
    case fileUpload
    case listLookup(country: String?, category: String?, limit: Int?, next: String?)
    case detailLookup(activityId: String)
    case keep(activityId: String, request: ActivityKeepRequest)
    case newListLookup(country: String?, category: String?)
    case search(title: String?)
    case keepLookup(country: String?, category: String?, limit: Int?, next: String?)
}

extension ActivityAPI: Router {
    var path: String {
        switch self {
        case .fileUpload:
            return "/v1/activities/files"
        case .listLookup:
            return "/v1/activities"
        case .detailLookup(let id):
            return "/v1/activities/\(id)"
        case .keep(let id, _):
            return "/v1/activities/\(id)/keep"
        case .newListLookup:
            return "/v1/activities/new"
        case .search:
            return "/v1/activities/search"
        case .keepLookup:
            return "/v1/activities/keeps/me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fileUpload, .keep:
            return .post
        case .listLookup, .detailLookup, .newListLookup, .search, .keepLookup:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .fileUpload:
            return [
                "Authorization": TokenManager.shared.accessToken ?? "",
                "SeSACKey": Config.sesacKey,
                "Content-Type": "multipart/form-data"
            ]
        case .listLookup, .detailLookup, .newListLookup, .search, .keepLookup:
            return [
                "Authorization": TokenManager.shared.accessToken ?? "",
                "SeSACKey": Config.sesacKey
            ]
        case .keep:
            return [
                "Authorization": TokenManager.shared.accessToken ?? "",
                "SeSACKey": Config.sesacKey,
                "Content-Type": "application/json"
            ]
        }
    }
    
    var params: Parameters {
        switch self {
        case .fileUpload:
            return [:]
        case .listLookup(let country, let category, let limit, let next), 
                .keepLookup(let country, let category, let limit, let next):
            return [
                "country": country,
                "category": category,
                "limit": limit,
                "next": next
            ]
        case .detailLookup(let id), .keep(let id, _):
            return [
                "activity_id": id
            ]
        case .newListLookup(let country, let category):
            return [
                "country": country,
                "category": category
            ]
        case .search(let title):
            return [
                "title": title
            ]
        }
    }
    
    var requestBody: Encodable? {
        switch self {
        case .fileUpload:
            return nil
        case .listLookup:
            return nil
        case .detailLookup:
            return nil
        case .keep(_, let request):
            return request
        case .newListLookup:
            return nil
        case .search:
            return nil
        case .keepLookup:
            return nil
        }
    }
}
