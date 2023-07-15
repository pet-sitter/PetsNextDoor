//
//  LoginViewReducer.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/09.
//

import Foundation

final class LoginViewReducer: Reducer {

  struct State: Equatable {
    var isLoadingIndicatorAnimating: Bool = false
  }
  
  enum Action {
    case didTapKakaoLogin
    case didTapGoogleLogin
    case didTapAppleLogin
  }
  
  enum Feedback {
    case authenticationComplete
  }
  
  enum Output: ObservableOutput {
    case loginComplete
    case createAccountNeeded
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
    case .action(.didTapGoogleLogin):
      return .run { [weak self] send in
        do {
          try await self?.authenticationMiddleWare.beginGoogleLogin()
          await send(.authenticationComplete)
        } catch {
          print("❌ error: \(error)")
        }

      }
      
    case .feedback(.authenticationComplete):
      return .output(.createAccountNeeded)

    default:
      return .none
      
    }
  
    
  }
  

  
  
}
