//
//  ComponentBuilder.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/22.
//

import Foundation

@resultBuilder
struct ComponentBuilder2: ComponentBuildable {

  var components: [any Component]
  
  func buildComponents() -> [any Component] {
    components
  }
    
  static func buildBlock() -> ComponentBuilder2 {
    ComponentBuilder2()
  }
  
  static func buildBlock(_ components: any ComponentBuildable...) -> ComponentBuilder2 {
    var componentArray: [any Component] = []
    components.forEach { componentArray.append(contentsOf: $0.buildComponents()) }
    return ComponentBuilder2(components: componentArray)
  }
  
  static func buildOptional(_ component: (any Component)?) -> (any Component)? {
    component
  }
  
  static func buildEither(first component: any ComponentBuildable) -> any ComponentBuildable {
    component
  }
  
  static func buildEither(second component: any ComponentBuildable) -> any ComponentBuildable {
    component
  }
}

extension ComponentBuilder2 {
  
  init() {
    components = []
  }
  
  init(_ c: any ComponentBuildable) {
    components = c.buildComponents()
  }
  
  init(components: any ComponentBuildable...) {
    var componentArray: [any Component] = []
    components.forEach { componentArray.append(contentsOf: $0.buildComponents()) }
    self.components = componentArray
  }
}
