//
//  Dictionary+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/25.
//

import Foundation

extension Dictionary {
  
  static var builder: Builder { Builder() }
  
  final class Builder {
    
    private var dictionary: [String : Any] = [:]
    
    func `set`(key: String, value: Any) -> Self {
      dictionary[key] = value
      return self
    }
    
    func build() -> [String : Any] {
      return dictionary
    }
    
    func setOptional(key: String, value: Any?) -> Self {
      if let value {
        dictionary[key] = value
      }
      return self
    }
  }
}
