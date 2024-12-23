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
  
  struct BreedInfo: Codable, Hashable {
    let id: String
    let petType: PND.PetType
    let name: String
    
    enum CodingKeys: String, CodingKey {
      case id
      case petType = "petType"
      case name
    }
  }
}
