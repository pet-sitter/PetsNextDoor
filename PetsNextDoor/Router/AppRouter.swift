//
//  AppRouter.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import UIKit
import Combine
import ComposableArchitecture

final class AppRouter {

  static let shared = AppRouter()


  var visibleViewController: UIViewController? { UIApplication.topViewController() }
  
  var currentWindow: UIWindow? {
    (visibleViewController?.view.window?.windowScene?.delegate as? SceneDelegate)?.window
  }

  private init() {}
  
  
  


}

