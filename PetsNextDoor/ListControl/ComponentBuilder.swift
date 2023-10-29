//
//  ComponentBuilder.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/22.
//

import Foundation

@resultBuilder
struct ComponentBuilder: ComponentBuildable {

  var components: [any Component]
  
  func buildComponents() -> [any Component] {
    components
  }
    
  static func buildBlock() -> ComponentBuilder {
    ComponentBuilder()
  }
  
  static func buildBlock(_ components: any ComponentBuildable...) -> ComponentBuilder {
    var componentArray: [any Component] = []
    components.forEach { componentArray.append(contentsOf: $0.buildComponents()) }
    return ComponentBuilder(components: componentArray)
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

extension ComponentBuilder {
  
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
