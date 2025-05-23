//
//  UserEntity.swift
//  FLOV
//
//  Created by 조우현 on 5/20/25.
//

import Foundation

struct UserEntity {
  let id: String
  let email: String?
  let nick: String
  let profileImageURL: String?
  let phoneNumber: String?
  let introduction: String?
}

struct AuthCredentialsEntity {
  let accessToken: String
  let refreshToken: String
}

struct AuthResultEntity {
  let user: UserEntity
  let credentials: AuthCredentialsEntity
}
