//
//  SectionsBuildable.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/27.
//

import Foundation

protocol SectionsBuildable {
  func buildSections() -> [Section]
}

extension Optional: SectionsBuildable where Wrapped: SectionsBuildable {
  
  func buildSections() -> [Section] {
    return self?.buildSections() ?? []
  }
}


@resultBuilder
struct SectionBuilder: SectionsBuildable {
  
  var sections: [Section]
  
  func buildSections() -> [Section] {
    sections
  }
  
  static func buildBlock() -> SectionBuilder {
    SectionBuilder()
  }
  
  static func buildBlock(_ c: any SectionsBuildable) -> SectionBuilder {
    SectionBuilder(c)
  }
  
  static func buildOptional(_ component: ( Section)?) -> ( Section)? {
    component
  }
  
  static func buildEither(first component: any SectionsBuildable) -> any SectionsBuildable {
    component
  }
  
  static func buildEither(second component: any SectionsBuildable) -> any SectionsBuildable {
    component
  }


}

extension SectionBuilder {
  
  init() {
    sections = []
  }
  
  init(_ s: any SectionsBuildable) {
    sections = s.buildSections()
  }
}
