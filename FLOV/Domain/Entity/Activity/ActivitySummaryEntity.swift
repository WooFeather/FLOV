//
//  ActivitySummaryEntity.swift
//  FLOV
//
//  Created by 조우현 on 5/20/25.
//

import Foundation

struct ActivitySummaryEntity {
    let id: String
    let title: String?
    let country: String?
    let category: String?
    let thumbnailURLs: [String]
    let location: (latitude: Double, longitude: Double)
    let originalPrice: Int
    let finalPrice: Int
    let tags: [String]
    let pointReward: Int?
    let isAdvertisement: Bool?
    var isKeep: Bool?
    var keepCount: Int?
}
