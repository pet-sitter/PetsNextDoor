//
//  LoginState.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/03.
//

import Foundation

struct LoginState: Codable {
  var isLoading: Bool = false
}

extension LoginState {
  
  static let reducer: Reducer<Self> = { state, action in
    
    var newState = state
    
    switch action {
    
    case LoginStateAction.didTapKakaoLogin:
      newState.isLoading = true
      
    case LoginStateAction.didTapGoogleLogin:
      newState.isLoading = true
      
    case LoginStateAction.didTapKakaoLogin:
      newState.isLoading = true
      
    default: break
    }
    
    return newState
  }
}

enum LoginStateAction: Action, Codable {
  case didTapKakaoLogin
  case didTapGoogleLogin
  case didTapAppleLogin
}
