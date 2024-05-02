//
//  UserDataCenter.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/05/01.
//

import Foundation

actor UserDataCenter {
  
  private(set) var hasPetsRegistered: Bool = false
  
  func setUserHasPetsRegistered(to value: Bool) {
    PNDLogger.default.debug("UserDataCenter : setting user has pets registered to: \(value)")
    self.hasPetsRegistered = value
  }
}

