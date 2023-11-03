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
  var onEditingChanged: (((String?, any Component)) -> Void)? { get }
  func onEditingChanged(_ action: @escaping (((String?, any Component))) -> Void) -> Self
}

