//
//  Publisher+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import Foundation
import Combine

extension Publisher where Self.Failure == Never {
  
  func assignNoRetain<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable where Root: AnyObject {
    sink { [weak object] (value) in
      object?[keyPath: keyPath] = value
    }
  }
}
