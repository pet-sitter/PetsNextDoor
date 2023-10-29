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
  
  
  
  static func buildArray(_ components: [[any Component]]) -> [any Component] {
    components.flatMap { $0 }
  }
  
  static func buildBlock(_ components: [any Component]...) -> [any Component] {
    components.flatMap { $0 }
  }
  
  static func buildExpression(_ expression: any Component) -> [any Component] {
    [expression]
  }
}

func ComponentBuilder(@ComponentResultBuilder components: () -> [any Component]) -> [any Component] {
  return components()
}

