//
//  ComponentModifier.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/03.
//

import Foundation

protocol TouchableComponent {
  
  associatedtype AnyComponent: Component

  var onTouchAction: ((AnyComponent) -> Void)? { get }
  func onTouch(_ action: @escaping ((AnyComponent) -> Void)) -> Self
}


protocol ContainsTextField {
  
  associatedtype AnyComponent: Component
  
  var onEditingChanged: (((String?, AnyComponent)) -> Void)? { get }
  func onEditingChanged(_ action: @escaping (((String?, AnyComponent))) -> Void) -> Self
}


protocol ContainsSegments {
  var onSegmentChange: ((Int) -> Void)? { get }
  func onSegmentChange(_ action: ((Int) -> Void)?) -> Self
}
