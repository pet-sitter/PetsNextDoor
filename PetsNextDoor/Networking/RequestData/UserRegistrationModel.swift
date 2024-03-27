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
    var fullname: String    // Social 계정 이름 (ex. 김영채/Young Chae KIM)
    var nickname: String    // 사용자가 직접 설정하는 이름 (SetProfileView에서)
    var profileImageId: Int?
    
    /**
      Init 단계에서는 nickname과 profileImageId를 받지 않는다 - 이후 SetProfileView에서 별도로 입력 받는다.
     */
    init(
      email: String,
      fbProviderType: FBProviderType,
      fbUid: String,
      fullname: String
    ) {
      self.email = email
      self.fbProviderType = fbProviderType
      self.fbUid = fbUid
      self.fullname = fullname
      self.nickname = ""
      self.profileImageId = nil
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
