//
//  SOSPostDetailModel.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/25.
//

import Foundation

extension PND {
  
  struct SOSPostDetailModel: Codable {
    
    let authorId: Int?
    let careType: CareType?
    let carerGender: PND.Sex?
    @DefaultEmptyArray var conditions: [PND.Condition]
    @DefaultEmptyString var content: String
    let createdAt: String?
    let dateEndAt: String?
    let dateStartAt: String?
    let id: Int?
    @DefaultEmptyArray var media: [PND.MediaModel]
    @DefaultEmptyArray var pets: [PND.Pet]
    let reward: String?
    let rewardAmount: String?
    let thumbnailId: Int?
    let timeEndAt: String?
    let timeStartAt: String?
    @DefaultEmptyString var title: String
    let updatedAt: String?
  
    
    enum CodingKeys: String, CodingKey {
      case authorId = "author_id"
      case careType = "care_type"
      case carerGender = "carer_gender"
      case conditions, content
      case createdAt = "created_at"
      case dateEndAt = "date_end__at"
      case dateStartAt = "date_start_at"
      case id, media, pets, reward
      case rewardAmount = "reward_amount"
      case thumbnailId = "thumbnail_id"
      case timeEndAt = "time_end_at"
      case timeStartAt = "time_start_at"
      case title
      case updatedAt = "updated_at"
    }
  }
  
  enum CareType: String, Codable {
    
    case foster = "foster"
    case visiting = "visiting"
    
    enum CodingKeys: String, CodingKey {
      case foster, visiting
    }
    
    init(from decoder: Decoder) throws {
      self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .foster
    }
    
  }
  
}
