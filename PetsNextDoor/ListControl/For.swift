//
//  For.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/31.
//

import Foundation

struct For<Element> {
  
  var elements: [Element]
  
  init() {
    elements = []
  }
}

//MARK: - ComponentBuildable

extension For: ComponentBuildable where Element == any Component {
  
  init(@ComponentBuilder component: () -> ComponentBuildable) {
    self.elements = component().buildComponents()
  }
  
  init<S: Sequence>(
    each data: S,
    component: (S.Element) -> any ComponentBuildable
  ) {
    self.elements = data.flatMap { component($0).buildComponents() }
  }
  
  func buildComponents() -> [any Component] {
    elements
  }
}


//MARK: - SectionsBuildable

extension For: SectionsBuildable where Element == Section {
  
  init(@SectionBuilder sections: () -> SectionsBuildable) {
    self.elements = sections().buildSections()
  }
  
  init<S: Sequence>(
    _ data: S,
    section: (S.Element) -> any SectionsBuildable
  ) {
    self.elements = data.flatMap { section($0).buildSections() }
  }
  
  func buildSections() -> [Section] {
    elements
  }
}
