//
//  BreedListResponseModel.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/16.
//

import Foundation

extension PND {
  
  struct BreedListResponseModel: Codable {
    let page: Int
    let size: Int
    let items: [BreedInfo]
  }
  
  struct BreedInfo: Codable {
    let id: Int
    let petType: PND.PetType
    let name: String
    
    enum CodingKeys: String, CodingKey {
      case id
      case petType = "pet_type"
      case name
    }
  }
}
