//
//  Routable.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import Foundation
import Combine

protocol Routable {
  
  var outputStream: AsyncPublisher<PassthroughSubject<ObservableOutput, Never>> { get }
  
  func observeOutputStream()
}
