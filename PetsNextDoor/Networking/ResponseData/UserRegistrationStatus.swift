//
//  UserRegistrationStatus.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/25.
//

import Foundation

//MARK: - 사용자 가입 상태 조회 응답

extension PND {
  struct UserRegistrationStatus: Codable {
    let fbProviderType: String
    let status: RegistrationStatus
    
    enum CodingKeys: String, CodingKey {
      case fbProviderType, status
    }
  }
  
  enum RegistrationStatus: String, Codable {
    
    case registered    = "REGISTERED"
    case notRegistered = "NOT_REGISTERED"
    
    enum CodingKeys: String, CodingKey {
      case registered, notRegistered
    }
    
    init(from decoder: Decoder) throws {
      self = try RegistrationStatus(
        rawValue: decoder.singleValueContainer().decode(RawValue.self)
      ) ?? .notRegistered
    }
  }
}
