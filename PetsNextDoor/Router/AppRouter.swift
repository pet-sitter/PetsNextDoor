//
//  AppRouter.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import UIKit
import Combine
import ComposableArchitecture

enum NavigationOption {
  case push
  case presentFullScreen
  case presentModally
}

final class AppRouter: Routable {

  static let shared = AppRouter()

  private(set) var rootViewController: RootViewController!

  var visibleViewController: UIViewController? { UIApplication.topViewController() }

  private init() {}
  
  private var destinationSubscription: AnyCancellable?
  
  private init() {}

  func route(to destination: PND.Destination) {
    Task {
      await MainActor.run {
        route(destination)
      }
    }
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
      
    case .authenticatePhoneNumber:

			
    case .main(let window):
      break

    default: break
    }
  }

}

