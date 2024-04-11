//
//  UserDefaultsManager.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/04/01.
//

import Foundation

protocol UserDefaultsManageable {
  func resetAllKeys()
  func set(_ key: UserDefaultsKey, to value: Any)
  func get(_ key: UserDefaultsKey) -> Any?
  func remove(_ key: UserDefaultsKey)
  func setBoolean(_ key: UserDefaultsKey, to value: Bool)
}

enum UserDefaultsKey: String, CaseIterable, CodingKey {
  case isLoggedIn
}

struct UserDefaultsManager: UserDefaultsManageable {
  
  static let shared: UserDefaultsManager = .init()
  
  func resetAllKeys() {
    UserDefaultsKey.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
  }

  func set(_ key: UserDefaultsKey, to value: Any) {
    UserDefaults.standard.set(value, forKey: key.rawValue)
  }
  
  func get(_ key: UserDefaultsKey) -> Any? {
    UserDefaults.standard.value(forKey: key.rawValue)
  }
  
  func remove(_ key: UserDefaultsKey) {
    UserDefaults.standard.removeObject(forKey: key.rawValue)
  }
   
  func setBoolean(_ key: UserDefaultsKey, to value: Bool) {
    UserDefaults.standard.set(value, forKey: key.rawValue)
  }
}
