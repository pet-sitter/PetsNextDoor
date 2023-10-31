//
//  HashableViewModel.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/31.
//

import Foundation

class HashableViewModel: Hashable, Equatable {
  
  let uuid = UUID()
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(uuid)
  }
  
  static func == (lhs: HashableViewModel, rhs: HashableViewModel) -> Bool {
    lhs.uuid == rhs.uuid
  }
}

