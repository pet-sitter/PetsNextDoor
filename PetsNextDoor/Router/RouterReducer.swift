
//
//  RouterReducer.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/29.
//

import UIKit
import ComposableArchitecture

struct Router<Screen: Equatable & ViewProvidable>: Reducer {

  struct State: Equatable {
    
    var currentNavigationController: UINavigationController? {
      UIApplication.topViewController()?.navigationController
    }
    
    var currentWindow: UIWindow? {
      (UIApplication.topViewController()?.view.window?.windowScene?.delegate as? SceneDelegate)?.window
    }
  }
  
  enum Action: Equatable {
		case navigate(withLogic: CustomNavigationLogic)		/// 사용자 커스텀 handler
    case pushScreen(Screen, animated: Bool = true)
    case popScreen(animated: Bool = true)
    case popToRootScreen(animated: Bool = true)
    case presentFullScreen(Screen, animated: Bool = true)
    case presentModal(Screen, animated: Bool = true)
    case changeRootScreen(toScreen: Screen)
  }

  @MainActor
  func reduce(
    into state: inout State,
    action: Action
  ) -> Effect<Action> {
 
    switch action {
		case let .navigate(navigationLogic):
      navigationLogic.handler()
      
    case let .pushScreen(screen, animated):
      state.currentNavigationController?.pushViewController(screen.createView(), animated: animated)
      
    case let .popScreen(animated):
      state.currentNavigationController?.popViewController(animated: animated)
      
    case let .popToRootScreen(animated):
      state.currentNavigationController?.popToRootViewController(animated: animated)
      
    case let .presentFullScreen(screen, animated):
      let vc = screen.createView()
      vc.modalPresentationStyle = .overFullScreen
      state.currentNavigationController?.present(vc, animated: animated)
      
    case let .presentModal(screen, animated):
      state.currentNavigationController?.present(screen.createView(), animated: animated)
      
    case let .changeRootScreen(screen):
      state.currentWindow?.rootViewController = screen.createView()
      state.currentWindow?.makeKeyAndVisible()
    }
    return .none
  }
  
  
	final class CustomNavigationLogic: Equatable {
		
	 let handler: (() -> Void)

	 init(_ handler: @escaping () -> Void) {
		 self.handler = handler
	 }
	 
	 static func == (lhs: CustomNavigationLogic, rhs: CustomNavigationLogic) -> Bool {
		 lhs === rhs
	 }
 }
}


protocol ViewProvidable {
  typealias PresentableView = UIViewController
  func createView() -> PresentableView
}
