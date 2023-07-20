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

  private var rootViewController: RootViewController!

  var visibleViewController: UIViewController? { UIApplication.topViewController() }
  
  private var desinationSubscription: AnyCancellable?
  
  private init() {
    
  }
  
  private func observeDestination(destinationPublisher: StorePublisher<PND.Destination?>) {
    desinationSubscription = destinationPublisher
      .compactMap { $0 }
      .removeDuplicates()
      .withWeak(self)
      .sink { weakSelf, destination in
        Task { @MainActor in weakSelf?.route(to: destination) }
      }
  }

  @MainActor
  func route(to destination: PND.Destination) {
    route(destination)
  }

  @MainActor
  private func route(_ destination: PND.Destination) {
    
    
    switch destination {

    case .login(let window):

      rootViewController = RootViewController()
      
      let viewStore   = ViewStore(.init(initialState: LoginCore.State(), reducer: { LoginCore() } ))
      let loginVC     = LoginViewController(viewStore: viewStore)
    
      observeDestination(destinationPublisher: viewStore.publisher.nextDestination)
      
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

