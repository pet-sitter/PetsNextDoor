//
//  UserDefaults+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/12.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
  let key: String
  let defaultValue: T
  
  var wrappedValue: T {
    get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
    
    set { UserDefaults.standard.set(newValue, forKey: key) }
  }
}
