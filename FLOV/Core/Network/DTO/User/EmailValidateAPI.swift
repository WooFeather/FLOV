//
//  EmailValidateAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

// MARK: - EmailValidateRequest
struct EmailValidateRequest: Encodable {
    let email: String
}

// MARK: - EmailValidateResponse
struct EmailValidateResponse: Decodable {
    let message: String
}

// MARK: - Mapper
extension EmailValidateResponse {
    func toEntity() -> EmailValidationEntity {
        return EmailValidationEntity(message: message)
    }
}
