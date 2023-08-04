//
//  ComponentModifer.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/04.
//

import Foundation

protocol ComponentModifier: Component {
  
  associatedtype Wrapped: Component where Wrapped.ContentView == ContentView
  
  var wrapped: Wrapped { get }
}
