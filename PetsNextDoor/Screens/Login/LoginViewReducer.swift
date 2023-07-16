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
  
  private let loginMiddleWare: LoginMiddleWare

  init(loginMiddleWare: LoginMiddleWare) {
    self.loginMiddleWare = loginMiddleWare
  }
  
  func reduce(
    message: Message<Action, Feedback>,
    into state: inout State
  ) -> Effect<Feedback, Output> {
    
    switch message {
    case .action(.didTapGoogleLogin):
      return .task { [weak self] dispatch in
        do {
          try await self?.loginMiddleWare.beginGoogleLogin()
          await dispatch(.authenticationComplete)
          
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
