//
//  NetworkError.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURLError // 잘못된 URL
    case transport(Error) // 네트워크 연결 실패
    case statusCode(Int) // HTTP 4xx/5xx
    case decoding(Error) // JSON 디코딩 실패
    case apiError(String) // 서버가 내려주는 message
    case corsError // CORS 등 특수 처리
}
