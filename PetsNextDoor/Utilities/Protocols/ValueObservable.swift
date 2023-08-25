//
//  ValueObservable.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/24.
//

import Foundation
import Combine

protocol ValueBindable {
  associatedtype ObservingValue
  @discardableResult
  func bindValue(_ valuePublisher: AnyPublisher<ObservingValue, Never>) -> Self
}

