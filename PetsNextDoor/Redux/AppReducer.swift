//
//  AppReducer.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/16.
//

import UIKit

final class AppReducer: Reducer {

  struct State: Equatable {
    
  }
  
  enum Action {
    case willConnectTo(window: UIWindow)
  }
  
  enum Feedback {
    
  }
  
  enum Output: ObservableOutput {
    case loginIsRequired(window: UIWindow)
    case mainPageIsRequired(window: UIWindow)
  }
  
  private let authenticationMiddleWare: AuthenticationMiddleWare
  
  init(authenticationMiddleWare: AuthenticationMiddleWare) {
    self.authenticationMiddleWare = authenticationMiddleWare
  }
  
  func reduce(
    message: Message<Action, Feedback>,
    into state: inout State
  ) -> Effect<Feedback, Output> {
    
    switch message {
    case .action(.willConnectTo(let window)):
      
      if authenticationMiddleWare.checkIfUserIsLoggedIn() {
        return .output(.mainPageIsRequired(window: window))
      } else {
        return .output(.loginIsRequired(window: window))
      }
      
      
      
    case .feedback:
      return .none
 
    }
  }
}
