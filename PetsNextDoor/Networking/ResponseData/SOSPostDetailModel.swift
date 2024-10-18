//
//  SOSPostDetailModel.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/25.
//

import Foundation

extension PND {
  
  struct SOSPostDetailModel: Codable, Equatable {
    
    let id: String
    var authorId: Int?
    var author: Author?
    
    @DefaultEmptyString var title: String
    @DefaultEmptyString var content: String
    @DefaultEmptyArray var media: [PND.MediaModel]
    @DefaultEmptyArray var conditions: [PND.Condition]
    @DefaultEmptyArray var pets: [PND.Pet]
    
    let reward: String?
    let rewardType: PND.RewardType?
    
    @DefaultEmptyArray var dates: [PND.Date]
    let careType: CareType
    let carerGender: PND.Sex
    let createdAt: String?
    let updatedAt: String?

    let thumbnailId: Int?

    enum CodingKeys: String, CodingKey {
      case id
      case authorId
      case author
      case title
      case content
      case media
      case conditions
      case pets
      case reward
      case rewardType
      case dates
      case careType
      case carerGender
      case createdAt
      case updatedAt
      case thumbnailId
    }
  }
  
  enum CareType: String, Codable {
    
    case foster = "foster"
    case visiting = "visiting"
    
    var description: String {
      switch self {
      case .foster:   "위탁 돌봄"
      case .visiting: "방문 돌봄"
      }
    }
    
    enum CodingKeys: String, CodingKey {
      case foster, visiting
    }
    
    init(from decoder: Decoder) throws {
      self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .foster
    }
    
  }
  
  struct Author: Codable, Hashable {
    
    let id: String
    let nickname: String
    let profileImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
      case id, nickname, profileImageUrl
    }
  }
  
}
