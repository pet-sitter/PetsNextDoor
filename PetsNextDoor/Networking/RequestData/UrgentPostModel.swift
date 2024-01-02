//
//  UrgenPostModel.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/30.
//

import Foundation

extension PND {
  
  struct UrgentPostModel: Codable {
    let careType: PND.CareType
    let carerGender: PND.Sex
    let conditionIds: [Int]
    let content: String
    let dateEndAt: String
    let dateStartAt: String
    let imageIds: [Int]
    let petIds: [Int]
    let reward: String
    let rewardAmount: String
    let timeEndAt: String
    let timeStartAt: String
    let title: String
    
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
      case timeEndAt = "time_end_at"
      case timeStartAt = "time_start_at"
      case title
    }
  }
}
