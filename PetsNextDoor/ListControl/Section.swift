//
//  Section.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/22.
//

import Foundation

struct Section {
  
  var id: any Hashable
  
  var cells: [any Component]
  
  init<C: Swift.Collection>(id: any Hashable = UUID(), components: C) where C.Element == any Component {
    self.id = id
    self.cells = Array(components)
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
