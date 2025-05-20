//
//  RefreshAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

// MARK: - RefreshResponse
struct RefreshResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
