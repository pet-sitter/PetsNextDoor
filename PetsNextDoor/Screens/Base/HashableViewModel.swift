//
//  HashableViewModel.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/31.
//

import Foundation

protocol HashableViewModel: Hashable, Identifiable {
  var uuid: UUID { get }
}

extension HashableViewModel {
  
  var uuid: UUID { UUID() }
  
  var id: String { uuid.uuidString }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(uuid)
  }
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.uuid == rhs.uuid
  }
}
