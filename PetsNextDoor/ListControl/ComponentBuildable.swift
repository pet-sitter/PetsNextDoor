//
//  ComponentBuildable.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/22.
//

import Foundation

protocol ComponentBuildable {
  func buildComponents() -> [any Component]
}

extension Optional: ComponentBuildable where Wrapped: ComponentBuildable {
  
  func buildComponents() -> [any Component] {
    return self?.buildComponents() ?? []
  }
}
