//
//  UserProfileModel.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/05/12.
//

import Foundation

extension PND {
  
  // 내 정보 조회 시 사용하는 모델
  struct UserProfileModel: Codable {
    let id: Int
    let email: String
    var fbProviderType: PND.FBProviderType?
    let fullname: String
    let nickname: String
    var profileImageUrl: String?
  }
}

extension PND {
  
  // 타 이용자 정보 조회 시 사용하는 모델
  struct UserInfoModel: Codable {
    let id: Int
    let nickname: String
    var profileImageUrl: String?
  }
}
