//
//  KFImage+.swift
//  FLOV
//
//  Created by 조우현 on 5/30/25.
//

import Foundation
import Kingfisher

extension KFImage {
    func configureCache(for policy: CachePolicy) -> KFImage {
        switch policy {
        case .memoryOnly:
            self
                .cacheMemoryOnly()
                .diskCacheAccessExtending(.none)
        case .diskOnly:
            self
                .diskCacheExpiration(.days(7))
        case .memoryAndDiskWithOriginal:
            self
                .cacheOriginalImage()
                .diskCacheExpiration(.days(7))
        }
    }
}
