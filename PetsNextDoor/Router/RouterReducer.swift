
//
//  RouterReducer.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/29.
//

import UIKit
import ComposableArchitecture

protocol RoutableState {
	var router: Router<PND.Destination>.State { get }
}

protocol RoutableAction {
	static func _routeAction(_: Router<PND.Destination>.Action) -> Self
}

struct Router<Screen: Equatable & ViewProvidable>: Reducer {

  struct State: Equatable {
    
    var currentNavigationController: UINavigationController? {
      UIApplication.topViewController()?.navigationController
    }
    
    var currentWindow: UIWindow? {
//      (UIApplication.topViewController()?.view.window?.windowScene?.delegate as? SceneDelegate)?.window
      nil
    }
  }
  
  enum Action: Equatable {
		case navigate(withLogic: CustomHandler)		/// 사용자 커스텀 handler
    case pushScreen(Screen, animated: Bool = true)
    case popScreen(animated: Bool = true)
    case popToRootScreen(animated: Bool = true)
    case presentFullScreen(Screen, animated: Bool = true, completion: CustomHandler? = nil)
    case presentModal(Screen, animated: Bool = true)
		case dismiss(completion: CustomHandler? = nil)
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
      
    case let .presentFullScreen(screen, animated, completion):
      let vc = screen.createView()
			let nc = BaseNavigationController(rootViewController: vc)
			nc.modalPresentationStyle = .overFullScreen
      state.currentNavigationController?.present(nc, animated: animated, completion: completion?.handler)
      
    case let .presentModal(screen, animated):
      state.currentNavigationController?.present(screen.createView(), animated: animated)
      
		case .dismiss(let customHandler):
			state.currentNavigationController?.dismiss(animated: true, completion: customHandler?.handler)
			
    case let .changeRootScreen(screen):
      state.currentWindow?.rootViewController = screen.createView()
      state.currentWindow?.makeKeyAndVisible()
    }
    return .none
  }
  
  
	final class CustomHandler: Equatable {
		
	 let handler: (@Sendable () -> Void)

	 init(_ handler: @Sendable @escaping () -> Void) {
		 self.handler = handler
	 }
	 
	 static func == (lhs: CustomHandler, rhs: CustomHandler) -> Bool {
		 lhs === rhs
	 }
 }
}


protocol ViewProvidable {
  typealias PresentableView = UIViewController
  func createView() -> PresentableView
}
