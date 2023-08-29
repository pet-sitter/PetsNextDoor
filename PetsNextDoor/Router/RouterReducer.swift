
//
//  RouterReducer.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/29.
//

import UIKit
import ComposableArchitecture


protocol ViewProvidable {
  typealias PresentableView = UIViewController
  func createView() -> PresentableView
}

struct Router<Screen: Equatable & ViewProvidable>: Reducer {

  struct State: Equatable {
    
    
  }
  
  enum Action: Equatable {
		case navigate(withLogic: CustomNavigationLogic)		/// 사용자 커스텀 handler
    case pushScreen(Screen, animated: Bool = true)
    case popScreen(animated: Bool = true)
    case popToRootScreen(animated: Bool = true)
    case changeRootScreen(toScreen: Screen, animated: Bool = true)
    case presentScreen(Screen, animated: Bool = true)
    case presentModal(Screen, animated: Bool = true)
  }
  
  func reduce(
    into state: inout State,
    action: Action
  ) -> Effect<Action> {
    switch action {
			
		case let .navigate(navigationLogic):
			navigationLogic.handler()
			
    case let .pushScreen(screen, animated):
      currentNavigationController?.pushViewController(
        screen.createView(),
        animated: animated
      )
      
      
      
    default: break

//    case let .popScreen(animated):
//
//    case let .popToRootScreen(animated):
//
//    case let .changeRootScreen(screen, animated):
//
//    case let .presentScreen(animated):
//
//    case let .presentModal(animated):


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

extension Router: Routable {
  
  @MainActor
  func route(to destination: PND.Destination) {
    print("✅ route to des: \(destination)")
  }
}
