//
//  List.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/27.
//

import Foundation

struct List<Element> {
  
  var elements: [Element]
  
  init() {
    elements = []
  }
}

//MARK: - ComponentBuildable List

extension List: ComponentBuildable where Element == any Component {
 
  init(@ComponentBuilder component: () -> ComponentBuildable) {
    self.elements = component().buildComponents()
  }
  
  init<S: Sequence>(
    of data: S,
    component: (S.Element) -> any ComponentBuildable
  ) {
    self.elements = data.flatMap { component($0).buildComponents() }
  }
  
  func buildComponents() -> [any Component] {
    elements
  }
}

//MARK: - SectionsBuildable List

extension List: SectionsBuildable where Element == Section {
  
  init(@SectionBuilder sections: () -> SectionsBuildable) {
    self.elements = sections().buildSections()
  }
  
  init<S: Sequence>(
    of data: S,
    section: (S.Element) -> any SectionsBuildable
  ) {
    self.elements = data.flatMap { section($0).buildSections() }
  }
  
  func buildSections() -> [Section] {
    elements
  }
}
