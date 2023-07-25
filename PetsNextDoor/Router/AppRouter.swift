//
//  AppRouter.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import UIKit
import Combine
import ComposableArchitecture

final class AppRouter: Routable {

  static let shared = AppRouter()

  private(set) var rootViewController: RootViewController!

  var visibleViewController: UIViewController? { UIApplication.topViewController() }
  
  private var destinationSubscription: AnyCancellable?
  
  private init() {}

  @MainActor
  func route(to destination: PND.Destination) {
    route(destination)
  }

  @MainActor
  private func route(_ destination: PND.Destination) {
    
		switch destination {
			
		case .login(let window):
			
			rootViewController = RootViewController()
			
			let loginVC     = LoginViewController(
				store: .init(
					initialState: LoginFeature.State(),
					reducer: { LoginFeature()}
				),
				router: LoginRouter()
			)
			
			rootViewController.configureMainNavigationController(with: BaseNavigationController(rootViewController: loginVC))

      window.rootViewController = self.rootViewController
      window.overrideUserInterfaceStyle = .light
      window.makeKeyAndVisible()

			
    case .main(let window):
      break

    default: break
    }
  }

}

