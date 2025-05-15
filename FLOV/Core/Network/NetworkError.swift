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

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURLError:
            return "잘못된 URL입니다."
        case .transport(let error):
            return "네트워크 오류: \(error.localizedDescription)"
        case .statusCode(let code):
            return "서버 상태 코드: \(code)"
        case .decoding(let error):
            return "응답 파싱 실패: \(error.localizedDescription)"
        case .apiError(let message):
            return message
        case .corsError:
            return "CORS 오류가 발생했습니다."
        }
    }
}
