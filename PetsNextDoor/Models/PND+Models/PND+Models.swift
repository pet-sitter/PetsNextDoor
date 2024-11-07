//
//  PND+Models.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 11/29/23.
//

import Foundation

extension PND {
	
  enum PetType: String, Codable, Hashable {
		case dog = "dog"
		case cat = "cat"
    
    enum CodingKeys: String, CodingKey {
      case dog, cat
    }
    
    init(from decoder: Decoder) throws {
      self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .dog
    }
	}
  
  enum GenderType: String, Codable  {
    case male   = "male"
    case female = "female"
    case all    = "all"    // 상관없음 
  }
  
  enum EventType: String, Codable {
    case singleEvent    = "SINGLE"
    case recurringEvent = "RECURRING"
    
    var description: String {
      switch self {
      case .singleEvent:      "단기 이벤트"
      case .recurringEvent:   "정기 이벤트"
      }
    }
    
    enum CodingKeys: String, CodingKey {
      case singleEvent, recurringEvent
    }
    
    init(from decoder: Decoder) throws {
      self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .singleEvent
    }
    
  }
}
