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
    var dates: [PND.Date]
    var imageIds: [Int]
    var petIds: [Int]
    var reward: String
    var rewardType: PND.RewardType
    var title: String
    
    enum CodingKeys: String, CodingKey {
      case careType = "careType"
      case carerGender = "carerGender"
      case conditionIds = "conditionIds"
      case content
      case dates
      case imageIds = "imageIds"
      case petIds = "petIds"
      case reward
      case rewardType
      case title
    }
    
    static func `default`() -> Self {
      return .init(
        careType: .foster,
        carerGender: .male,
        conditionIds: [],
        content: "test content",
        dates: [
          Date(dateStartAt: "2024-04-01", dateEndAt: "2024-04-01"),
          Date(dateStartAt: "2024-04-02", dateEndAt: "2024-04-02")
        ],
        imageIds: [],
        petIds: [],
        reward: "reward",
        rewardType: .negotiable,
        title: "돌봄급구 구합니다!"
      )
    }
    
    static func empty() -> Self {
      return .init(
        careType: .foster,
        carerGender: .male,
        conditionIds: [],
        content: "",
        dates: [
          Date(dateStartAt: "2024-04-01", dateEndAt: "2024-04-01"),
          Date(dateStartAt: "2024-04-02", dateEndAt: "2024-04-02")
        ],
        imageIds: [],
        petIds: [],
        reward: "",
        rewardType: .negotiable,
        title: ""
      )
    }
  }
  
  struct Date: Codable, Hashable {
    let dateStartAt: String
    let dateEndAt: String
    
    enum CodingKeys: String, CodingKey {
      case dateStartAt
      case dateEndAt
    }
  }
}
