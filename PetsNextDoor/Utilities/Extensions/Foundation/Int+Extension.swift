//
//  Int+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/05/01.
//

import Foundation

extension Int {
  
  func asString() -> String {
    "\(self)"
  }
  
  static func randomStatusCode() -> Int {
    [200, 400, 500].randomElement()!
  }
}
