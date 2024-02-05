//
//  UrgenPostModel.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/30.
//

import Foundation

extension PND {
  
  struct UrgentPostModel: Codable, Hashable {
    var careType: PND.CareType
    var carerGender: PND.GenderType
    var conditionIds: [Int]
    var content: String
    var dateEndAt: String
    var dateStartAt: String
    var imageIds: [Int]
    var petIds: [Int]
    var reward: String
    var rewardAmount: String
    var title: String
    
    enum CodingKeys: String, CodingKey {
      case careType = "care_type"
      case carerGender = "carer_gender"
      case conditionIds = "condition_ids"
      case content
      case dateEndAt = "date_end_at"
      case dateStartAt = "date_start_at"
      case imageIds = "image_ids"
      case petIds = "pet_ids"
      case reward
      case rewardAmount = "reward_amount"
      case title
    }
    
    static func `default`() -> Self {
      return .init(
        careType: .foster,
        carerGender: .male,
        conditionIds: [],
        content: "test content",
        dateEndAt: "2024-01-28",
        dateStartAt: "2024-01-20",
        imageIds: [],
        petIds: [],
        reward: "reward",
        rewardAmount: "10000",
        title: "돌봄급구 구합니다!"
      )
    }
    
    static func empty() -> Self {
      return .init(
        careType: .foster,
        carerGender: .male,
        conditionIds: [],
        content: "",
        dateEndAt: "",
        dateStartAt: "",
        imageIds: [],
        petIds: [],
        reward: "",
        rewardAmount: "",
        title: ""
      )
    }
  }
}
