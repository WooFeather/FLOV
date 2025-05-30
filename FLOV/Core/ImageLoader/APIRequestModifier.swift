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
        var r = request
        r.url = URL(string: baseURL + "/v1" + (request.url?.path ?? ""))!
        r.setValue(apiKey, forHTTPHeaderField: "SeSACKey")
        if let token = accessToken {
            r.setValue(token, forHTTPHeaderField: "Authorization")
        }
        // 디버그 로그
        print("▶️ KF Request URL: \(r.httpMethod ?? "GET") \(r.url?.absoluteString ?? "")")
        print("▶️ KF Request Headers: \(r.allHTTPHeaderFields ?? [:])")
        return r
    }
}
