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
