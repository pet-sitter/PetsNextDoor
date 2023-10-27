//
//  Renderer.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/27.
//

import UIKit

final class Renderer<Updater: PetsNextDoor.Updater> {
  
  let adapter: Updater.Adapter
  
  let updater: Updater
  
  weak var target: Updater.Target?
  
  var sectionData: [Section] {
    get { adapter.sectionData }
    set { render(newValue)    }
  }
  
  init(
    adapter: Updater.Adapter,
    updater: Updater,
    target: Updater.Target
  ) {
    self.adapter = adapter
    self.updater = updater
    self.target  = target
    updater.prepare(target: target, adapter: adapter)
  }

  func render(_ sectionData: [Section]) {
    
    guard let target else {
      adapter.sectionData = sectionData
      return
    }
    
    updater.performUpdates(
      target: target,
      adapter: adapter,
      sectionData: sectionData
    )
  }

  func render<S: SectionsBuildable>(@SectionBuilder sections: () -> S) {
    render(sections().buildSections())
  }
  
  func render<C: ComponentBuildable>(@ComponentBuilder2 components: () -> C) {
    render {
      Section(id: UUID(), cells: components)
    }
  }
}
