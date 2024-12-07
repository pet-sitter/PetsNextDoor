//
//  EventListResponseModel.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 12/2/24.
//

import Foundation

extension PND {
  
  struct EventListResponseModel: Codable {
    
    let items: [Event]
    let next: Pagination?
    let prev: Pagination?
  }
  
  struct Event: Codable, Equatable {
    
    let author: PND.Author?
    let createdAt: String?
    let description: String
    let fee: Int?
    let genderCondition: String?
    let id: String?
    let maxParticipants: Int?
    let media: PND.Media
    let name: String
    let recurringPeriod: RecurringPeriod
    let startAt: String
    let topics: [String]
    let type: PND.EventType
    let updatedAt: String?
  }
  
  struct Pagination: Codable {
    let uuid: String
    let valid: Bool
  }
  
  enum RecurringPeriod: String, Codable, Hashable {
    case daily = "DAILY"
    case weekly = "WEEKLY"
    case biweekly = "BIWEEKLY"
    case monthly = "MONTHLY"
    
    
    enum CodingKeys: String, CodingKey {
      case daily, weekly, biweekly, monthly
    }
    
    init(from decoder: Decoder) throws {
      self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .daily
    }
  }
  
  enum EventType: String, Codable, Hashable {
    case shortTerm = "SHORT_TERM"
    case recurring = "RECURRING"
    
    var description: String {
      switch self {
      case .shortTerm:  "단기 이벤트"
      case .recurring:  "정기 이벤트"
      }
    }

    enum CodingKeys: String, CodingKey {
      case shortTerm, recurring
    }
    
    init(from decoder: Decoder) throws {
      self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .shortTerm
    }
  }
}
