//
//  UserRegistrationModel.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/25.
//

import Foundation

//MARK: - 사용자 회원가입 요청 모델

extension PND {
  struct UserRegistrationModel: Codable, Equatable {
    var email: String
    var fbProviderType: FBProviderType
    var fbUid: String
    var fullname: String
    var nickname: String
    var profileImageId: Int
    
    init(email: String, fbProviderType: FBProviderType,  fbUid: String, fullname: String, profileImageId: Int) {
      self.email = email
      self.fbProviderType = fbProviderType
      self.fbUid = fbUid
      self.fullname = fullname
      self.nickname = ""         /// 회원가입 단계에서 유저한테 이후에 입력 받으므로 초반에는 empty String
      self.profileImageId = profileImageId
    }
  }
}

extension PND {
  
  enum FBProviderType: String, Codable, Equatable {
    
    case email  = "email"
    case google = "google"
    case apple  = "apple"
    case kakao  = "kakao"
    
    enum CodingKeys: String, CodingKey {
      case email, google, apple, kakao
    }
    
    init(from decoder: Decoder) throws {
      self = try FBProviderType(
        rawValue: decoder.singleValueContainer().decode(RawValue.self)
      ) ?? .email
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      switch self {
      case .email:
        try container.encode(self.rawValue, forKey: .email)
      case .google:
        try container.encode(self.rawValue, forKey: .google)
      case .apple:
        try container.encode(self.rawValue, forKey: .apple)
      case .kakao:
        try container.encode(self.rawValue, forKey: .kakao)
      }
    }
  }
}
