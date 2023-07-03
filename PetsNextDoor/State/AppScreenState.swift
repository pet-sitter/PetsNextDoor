//
//  AppScreenState.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/03.
//

import Foundation

enum AppScreenState: Codable {
  
  case login(LoginState)
  case homeScreen(HomeState)
  
  static let reducer: Reducer<Self> = { state, action in
    
    switch state {
    case .login(let state):
      return .login(LoginState.reducer(state, action))
      
    case .homeScreen(let state):
      return .homeScreen(HomeState.reducer(state, action))
    }
  }
  
  
}

enum AppScreen {
  
  case login
  case homeScreen
}
