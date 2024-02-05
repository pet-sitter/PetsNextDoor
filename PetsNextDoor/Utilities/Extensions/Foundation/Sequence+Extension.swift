//
//  Sequence+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/02/05.
//

import Foundation


extension Sequence {
  func asyncForEach(_ operation: (Element) async throws -> Void) async rethrows {
    for element in self {
      try await operation(element)
    }
  }
  
  func asyncCompactMap(_ operation: (Element) async throws -> Element?) async rethrows -> [Element] {
    var elements = [Element]()
    for element in self {
      if let mapped = try await operation(element) {
        elements.append(mapped)
      }
    }
    return elements
  }
}
