//
//  Group.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/27.
//

import Foundation

struct Group<Element> {
  
  var elements: [Element]
  
  init() {
    elements = []
  }
}

extension Group: ComponentBuildable where Element == any Component {
 
  init(@ComponentBuilder2 component: () -> ComponentBuildable) {
    self.elements = component().buildComponents()
  }
  
  init<Data: Sequence, C: ComponentBuildable>(
    of data: Data,
    component: (Data.Element) -> C
  ) {
    self.elements = data.flatMap { component($0).buildComponents() }
  }
  
  func buildComponents() -> [any Component] {
    elements
  }
}


extension Group: SectionsBuildable where Element == Section {
  
  init(@SectionBuilder sections: () -> SectionsBuildable) {
    self.elements = sections().buildSections()
  }
  
  init<Data: Sequence, S: SectionsBuildable>(
    of data: Data,
    section: (Data.Element) -> S
  ) {
    self.elements = data.flatMap { section($0).buildSections() }
  }
  
  func buildSections() -> [Section] {
    elements
  }
}
