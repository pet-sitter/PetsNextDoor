//
//  Adapter.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/22.
//

import Foundation

protocol Adapter: AnyObject {
  
  associatedtype Target: AnyObject
  
  var sectionData: [Section] { get set }
  var target: Target { get }
  
  func prepare()
  func reloadData(withSectionData sectionData: [Section])
}

extension Adapter {
  
  /// 특정 Section에 존재하는 모든 component를 반환한다.
  ///
  /// - Parameters:
  ///   - :
  ///
  /// - Returns:
  func components(inSection section: Int) -> [any Component] {
    return sectionData[section].components
  }

  /// 특정 indexPath에 존재하는 component를 반환한다.
  ///
  /// - Parameters:
  ///   - :
  ///   - :
  ///
  /// - Returns:
  func components(atIndexPath indexPath: IndexPath) -> any Component {
    return components(inSection: indexPath.section)[indexPath.row]
  }
}
