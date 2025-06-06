//
//  ProfileImageUploadAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/19/25.
//

import Foundation

// MARK: - ProfileImageUploadResponse
struct ProfileImageUploadResponse: Decodable {
    let profileImage: String?
}

// MARK: - Mapper
extension ProfileImageUploadResponse {
    func toEntity() -> ProfileImageEntity {
        return ProfileImageEntity(profileImage: profileImage)
    }
}
