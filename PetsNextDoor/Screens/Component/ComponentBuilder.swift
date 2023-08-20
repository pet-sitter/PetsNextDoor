//
//  ComponentBuilder.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/19.
//

import Foundation

@resultBuilder
struct ComponentResultBuilder {
  
  static func buildBlock(_ components: any Component...) -> [any Component] {
    var newComponents: [any Component] = []
    newComponents.append(contentsOf: components)
    return newComponents
  }
  
}

func ComponentBuilder(@ComponentResultBuilder components: () -> [any Component]) -> [any Component] {
  return components()
}

