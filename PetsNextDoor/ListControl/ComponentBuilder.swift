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
    ComponentBuilder(components: components.flatMap { $0.buildComponents()} )
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
    self.components = components.flatMap { $0.buildComponents() }
  }
}
