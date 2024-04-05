//
//  UserDefaultsManager.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/04/01.
//

import Foundation

struct UserDefaultsManager {
  
  static let shared: UserDefaultsManager = .init()
  
  enum Key: String, CaseIterable, CodingKey {
    case isLoggedIn
  }
  
  func resetAllKeys() {
    Key.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
  }

  func set(_ key: Key, to value: Any) {
    UserDefaults.standard.set(value, forKey: key.rawValue)
  }
  
  func get(_ key: Key) -> Any? {
    UserDefaults.standard.value(forKey: key.rawValue)
  }
  
  func remove(_ key: Key) {
    UserDefaults.standard.removeObject(forKey: key.rawValue)
  }
}
