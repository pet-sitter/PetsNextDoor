//
//  Renderer.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/27.
//

import UIKit

final class Renderer {
  
  let adapter: any Adapter
  
  var sectionData: [Section] {
    get { adapter.sectionData }
    set {   render(newValue)  }
  }
  
  init(adapter: any Adapter) {
    self.adapter = adapter
    self.adapter.prepare()
  }

  func render<C: Collection>(_ data: C) where C.Element == Section {
    adapter.reloadData(withSectionData: Array(data))
  }

  func render<S: SectionsBuildable>(@SectionBuilder sections: () -> S) {
    render(sections().buildSections())
  }
  
  func render<C: ComponentBuildable>(@ComponentBuilder components: () -> C) {
    renderSection {
      Section(id: UUID(), components: components)
    }
  }
  
  func renderSection<S: SectionsBuildable>(@SectionBuilder sections: () -> S) {
    render(sections().buildSections())
  }
}
