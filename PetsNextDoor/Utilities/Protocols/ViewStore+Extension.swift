//
//  ViewStore+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/31.
//

import Foundation

@propertyWrapper
struct Pulse<Value: Equatable>: Equatable {
  
  var value: Value {
    didSet { incrementValueUpdatedCount() }
  }
  
  var valueUpdatedCount = UInt.min
  
  init(wrappedValue: Value) {
    self.value = wrappedValue
  }
  
  var wrappedValue: Value {
    get { value }
    set { value = newValue }
  }
  
  var projectedValue: Pulse<Value> { return self }
  
  private mutating func incrementValueUpdatedCount() {
    valueUpdatedCount &+= 1
  }
}


import ComposableArchitecture
import Combine

extension ViewStore {
  
  func pulse<Value>(_ keyPath: KeyPath<ViewState, Pulse<Value>>) -> AnyPublisher<Value, Never> {
    publisher
      .map(keyPath)
      .removeDuplicates { $0.valueUpdatedCount == $1.valueUpdatedCount }
      .map(\.value)
      .eraseToAnyPublisher()
  }
  

}
