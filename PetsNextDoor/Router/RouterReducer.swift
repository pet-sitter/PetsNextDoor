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
//    case pushScreen(Screen, withLogic: Logic)
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
  
  
  
}

extension Router: Routable {
  
  @MainActor
  func route(to destination: PND.Destination) {
    print("✅ route to des: \(destination)")
  }
}
