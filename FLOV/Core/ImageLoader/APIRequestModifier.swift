//
//  APIRequestModifier.swift
//  FLOV
//
//  Created by 조우현 on 5/29/25.
//

import Foundation
import Kingfisher

struct APIRequestModifier: ImageDownloadRequestModifier {
    let baseURL: String
    let apiKey: String
    let accessToken: String?

    func modified(for request: URLRequest) -> URLRequest? {
        var request = request
        request.url = URL(string: baseURL + (request.url?.path ?? ""))!
        request.setValue(apiKey, forHTTPHeaderField: "SeSACKey")
        if let token = accessToken {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        #if DEBUG
        print("▶️ KF Request URL: \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "")")
        print("▶️ KF Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        #endif
        return request
    }
}
