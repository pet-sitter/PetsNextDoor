//
//  Pet.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/02/05.
//

import Foundation

extension PND {
  
  struct MyPetListModel: Codable, Equatable {
    let pets: [Pet]
  }
}
