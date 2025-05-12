//
//  EmailValidateAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/11/25.
//

import Foundation

struct EmailValidateRequest: Encodable {
    let email: String
}

struct EmailValidateResponse: Decodable {
    let message: String
}
