//
//  DeviceTokenUpdateAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/19/25.
//

import Foundation

// MARK: - DeviceTokenUpdateRequest
struct DeviceTokenUpdateRequest: Encodable {
    let deviceToken: String
}
