//
//  UploadFilesAPI.swift
//  FLOV
//
//  Created by 조우현 on 6/4/25.
//

import Foundation

// MARK: - UploadFilesRequest
struct UploadFilesRequest: Encodable {
    let files: [String]
}

// MARK: - UploadFilesResponse
struct UploadFilesResponse: Decodable {
    let files: [String]
}

// MARK: - Mapper
extension UploadFilesResponse {
    func toEntity() -> UploadFilesEntity {
        return .init(files: files)
    }
}
