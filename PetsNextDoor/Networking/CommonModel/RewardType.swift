//
//  RewardType.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/04/15.
//

import Foundation

extension PND {
  
  enum RewardType: String, CaseIterable, Codable {
    case fee        = "fee"
    case gifticon   = "gifticon"
    case negotiable = "negotiable"
    
    var text: String {
      switch self {
      case .fee:        "사례비"
      case .gifticon:   "기프티콘"
      case .negotiable: "협의가능"
      }
    }
    
    var prompt: String {
      switch self {
      case .fee:        "원"
      case .gifticon:   "기프티콘 종류"
      case .negotiable: "협의가능"
      }
    }

  }
}
