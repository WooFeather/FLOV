//
//  AdBannerEntity.swift
//  FLOV
//
//  Created by 조우현 on 5/25/25.
//

import Foundation

struct AdBannerEntity {
    let name: String
    let imageUrl: String
    let payload: PayloadEntity
}

struct PayloadEntity {
    let type: String
    let value: String
}
