//
//  AppRouter.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import UIKit
import Combine

final class AppRouter: Routable {
  
  static let shared = AppRouter(outputStream: AppStore.shared.outputStream)
  
  private var rootViewController: RootViewController!
  
  private(set) var outputStream: AsyncPublisher<PassthroughSubject<ObservableOutput, Never>>
  
  private init(outputStream: AsyncPublisher<PassthroughSubject<ObservableOutput, Never>>) {
    self.outputStream = outputStream
    observeOutputStream()
  }

  func observeOutputStream() {
    Task {
      for await output in outputStream {
        switch output {
          
        case AppReducer.Output.loginIsRequired(let window):
          await route(to: .login(onWindow: window))
          
        case AppReducer.Output.mainPageIsRequired(let window):
          await route(to: .main(onWindow: window))
     
        default: break
        }
      }
    }
  }
  
  @MainActor
  func route(to screen: ScreenType) {
    switch screen {
      
    case .login(let window):
      
      rootViewController = RootViewController()
      
      let reducer = LoginViewReducer(loginMiddleWare: LoginMiddleWare(loginService: LoginService()))
      let store   = Store(initialState: LoginViewReducer.State(), reducer: reducer)
      let router  = LoginRouter(outputStream: store.outputStream)
      let loginVC = LoginViewController(store: store, router: router)
      
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
