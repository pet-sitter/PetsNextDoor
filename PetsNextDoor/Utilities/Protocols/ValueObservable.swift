//
//  ValueObservable.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/24.
//

import Foundation
import Combine

protocol ValueBindable {
  
  var subscriptions: Set<AnyCancellable> { get }
  
  associatedtype ObservingValue
  @discardableResult
  func bindValue(_ valuePublisher: PNDPublisher<ObservingValue>) -> Self
}
