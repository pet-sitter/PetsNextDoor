//
//  OutputStreamObservable.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import UIKit
import Combine

protocol Routable: AnyObject {
  @MainActor
  func route(to destination: PND.Destination)
}
 
extension PND {
  
  enum Destination: Equatable {
    case main(onWindow: UIWindow?)
    case login(onWindow: UIWindow)
    case authenticatePhoneNumber
    case setInitialProfile
    case addPet
  }
}

