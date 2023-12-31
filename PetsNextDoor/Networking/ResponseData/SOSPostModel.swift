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
    
    let id: Int?
    let authorId: Int?
    @DefaultEmptyString var title: String
    @DefaultEmptyString var content: String
    @DefaultEmptyArray var media: [MediaModel]
    @DefaultEmptyArray var conditions: [Condition]
    @DefaultEmptyArray var pets: [Pet]
    @DefaultEmptyString var reward: String
    @DefaultEmptyString var date_start_at: String
    @DefaultEmptyString var date_end_at: String
    @DefaultEmptyString var time_start_at: String
    @DefaultEmptyString var time_end_at: String
    @DefaultEmptyString var care_type: String
    let carer_gender: PND.Sex?
    @DefaultEmptyString var reward_amount: String
    let thumbnail_id: Int?
  }
  
  struct MediaModel: Codable {
    
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
  
  struct Condition: Codable {
    let ID: Int?
    let Name: String
  }
  
  struct Pet: Codable {
    let id: Int?
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
    
    enum CodingKeys: String, CodingKey {
      case male, female
    }
    
    init(from decoder: Decoder) throws {
      self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .male
    }
  }

}
