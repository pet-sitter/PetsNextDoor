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
  
  init<C: Swift.Collection>(id: any Hashable, cells: C) where C.Element == any Component {
    self.id = id
    self.cells = Array(cells)
  }
  
  init(id: any Hashable, @ComponentBuilder2 cells: () -> any ComponentBuildable) {
    self.init(id: id, cells: cells().buildComponents())
  }
  
}


extension Section: SectionsBuildable {
  func buildSections() -> [Section] {
    return [self]
  }
}
