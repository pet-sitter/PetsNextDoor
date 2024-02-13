//
//  SOSPostModel.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/19.
//

import Foundation

extension PND {
  
  struct SOSPostListModel: Codable {
    let page: Int
    let size: Int
    let items: [SOSPostModel]
  }
  
  struct SOSPostModel: Codable {
    
    let id: Int
    let authorId: Int?
    @DefaultEmptyString var title: String
    @DefaultEmptyString var content: String
    @DefaultEmptyArray var media: [MediaModel]
    @DefaultEmptyArray var conditions: [Condition]
    @DefaultEmptyArray var pets: [Pet]
    @DefaultEmptyString var reward: String
    @DefaultEmptyString var date_start_at: String
    @DefaultEmptyString var date_end_at: String
    var care_type: PND.CareType
    let carer_gender: PND.Sex?
    @DefaultEmptyString var reward_amount: String
    let thumbnail_id: Int?
  }
  
  struct MediaModel: Codable, Equatable {
    
    let id: Int?
    let mediaType: MediaType
    let url: String
    let createdAt: String
  }
  
  enum MediaType: String, Codable {
    
    case image    = "image"
    case unknown  = "unknown"
    
    enum CodingKeys: String, CodingKey {
      case image, unknown
    }
    
    init(from decoder: Decoder) throws {
      self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
  }
  
  struct Condition: Codable, Hashable, Equatable {
    let id: Int
    let name: String
    var isSelected: Bool = false
  }
  
  struct Pet: Codable, Hashable {
    let id: Int
    let name: String
    let pet_type: PND.PetType
    let sex: PND.Sex
    let neutered: Bool
    let breed: String
    let birth_date: String
    let weight_in_kg: Int
  }
  
  enum Sex: String, Codable {
    
    case male    = "male"
    case female  = "female"
    
    var description: String {
      switch self {
      case .male:   "남자만"
      case .female: "여자만"
      }
    }
    
    enum CodingKeys: String, CodingKey {
      case male, female
    }
    
    init(from decoder: Decoder) throws {
      self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .male
    }
  }
}
