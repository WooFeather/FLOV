//
//  Router.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation
import Alamofire

enum RouterError: Error, LocalizedError {
    case invalidURLError
    case encodingError
    case network
    
    var errorDescription: String? {
        switch self {
        case .invalidURLError:
            "잘못된 URL"
        case .encodingError:
            "인코딩 에러"
        case .network:
            "요청 실패"
        }
    }
}

protocol Router: URLRequestConvertible {
    var endpoint: String { get }
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var params: Parameters { get }
    var encoding: ParameterEncoding? { get }
    var requestBody: Encodable? { get }
}

// 공통 로직을 위한 기본 구현
extension Router {
    
    var endpoint: String {
        baseURL + path
    }
    
    var baseURL: String {
        return Config.baseURL
    }
    
    var params: Parameters {
        return [:]
    }
    
    var encoding: ParameterEncoding? {
        return URLEncoding.default
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: endpoint) else {
            throw RouterError.invalidURLError
        }
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        
        // requestBody가 있는 경우 (POST with JSON)
        if let body = requestBody {
            request = try JSONParameterEncoder.default.encode(body, into: request)
        }
        // 파라미터가 있는 경우 (GET with query params)
        else if !params.isEmpty, let encoding = encoding {
            do {
                request = try encoding.encode(request, with: params)
            } catch {
                throw RouterError.encodingError
            }
        }
        
        return request
    }
}
