//
//  OutputStreamObservable.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import UIKit
import Combine

protocol Routable {
  @MainActor
  func route(to destination: PND.Destination)
}

extension Routable {
  var currentNavigationController: UINavigationController? {
    AppRouter
      .shared
      .rootViewController
      .mainNavigationController
  }
}
 
extension PND {
  
  indirect enum Destination: Equatable {
    case main(onWindow: UIWindow?)
    case login(onWindow: UIWindow)
    case authenticatePhoneNumber(AuthenticateFeature.State)
    case setInitialProfile(SetProfileFeature.State)
    case addPet
  }
}

