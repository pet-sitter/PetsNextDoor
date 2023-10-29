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
 
  init(@ComponentBuilder component: () -> ComponentBuildable) {
    self.elements = component().buildComponents()
  }
  
  init<ComponentData: Sequence, C: ComponentBuildable>(
    of data: ComponentData,
    component: (ComponentData.Element) -> C
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
  
  init<SectionData: Sequence, S: SectionsBuildable>(
    of data: SectionData,
    section: (SectionData.Element) -> S
  ) {
    self.elements = data.flatMap { section($0).buildSections() }
  }
  
  func buildSections() -> [Section] {
    elements
  }
}
