//
//  URL+.swift
//  FLOV
//
//  Created by 조우현 on 5/30/25.
//

import Foundation
import UniformTypeIdentifiers

extension URL {
    var isImageType: Bool {
        guard let uniformType = UTType(filenameExtension: pathExtension) else { return false }
        return uniformType.conforms(to: .image)
    }
    
    var isVideoType: Bool {
        guard let uniformType = UTType(filenameExtension: pathExtension) else { return false }
        return uniformType.conforms(to: .movie)
    }
}
