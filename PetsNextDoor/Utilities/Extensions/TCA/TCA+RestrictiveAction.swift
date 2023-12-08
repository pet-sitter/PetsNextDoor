//
//  RestrictiveAction.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/08.
//

import Foundation
import ComposableArchitecture

protocol RestrictiveAction {
  
  associatedtype ViewAction
  associatedtype DelegateAction
  associatedtype InternalAction
  
  static func view(_: ViewAction) -> Self
  static func delegate(_: DelegateAction) -> Self
  static func `internal`(_: InternalAction) -> Self
}
