//
//  FileUploadAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/21/25.
//

import Foundation

// MARK: - FileUploadResponse
struct FileUploadResponse: Decodable {
    let files: [String]
}

// MARK: - Mapper
extension FileUploadResponse {
    func toEntity() -> FileUploadEntity {
        return .init(files: files)
    }
}
