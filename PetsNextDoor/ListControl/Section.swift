//
//  Section.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/22.
//

import Foundation

struct Section {
  
  var id: any Hashable
  
  var components: [any Component]
  
  init<C: Swift.Collection>(id: any Hashable = UUID(), components: C) where C.Element == any Component {
    self.id = id
    self.components = Array(components)
  }
  
  init(id: any Hashable = UUID(), @ComponentBuilder components: () -> any ComponentBuildable) {
    self.init(id: id, components: components().buildComponents())
  }
}


extension Section: SectionsBuildable {
  func buildSections() -> [Section] {
    return [self]
  }
}

extension Section: ComponentBuildable {
  func buildComponents() -> [any Component] {
    components
  }
}
