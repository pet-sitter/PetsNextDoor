//
//  SOSPostDetailModel.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/25.
//

import Foundation

extension PND {
  
  struct SOSPostDetailModel: Codable, Equatable {
    
    let author: Author
    let careType: CareType
    let carerGender: PND.Sex
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
    @DefaultEmptyString var title: String
    let updatedAt: String?
  
    enum CodingKeys: String, CodingKey {
      case author
      case careType = "careType"
      case carerGender = "carerGender"
      case conditions, content
      case createdAt = "createdAt"
      case dateEndAt = "dateEndAt"
      case dateStartAt = "dateStartAt"
      case id, media, pets, reward
      case rewardAmount = "rewardAmount"
      case thumbnailId = "thumbnailId"
      case title
      case updatedAt = "updateAt"
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
    
    let id: Int
    let nickname: String
    let profileImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
      case id, nickname, profileImageUrl
    }
  }
  
}
