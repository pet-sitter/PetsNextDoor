//
//  IdentifierProvidable.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/04.
//

import Foundation

protocol IdentifierProvidable {
  static var identifier: String { get }
}

extension IdentifierProvidable {
  static var identifier: String {
    return String(describing: self)
  }
}
