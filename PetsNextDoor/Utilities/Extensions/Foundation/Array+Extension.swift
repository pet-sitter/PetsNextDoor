//
//  Array+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/19.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    if index >= self.count || index < 0 { return nil }
    return self[index]
  }
}
