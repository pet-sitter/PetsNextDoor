//
//  HomeState.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/03.
//

import Foundation

struct HomeState: Codable {
  
  var isRefreshControlAnimating: Bool = true
}

extension HomeState {
  
  static let reducer: Reducer<Self> = { state, action in
    
    var newState = state
    
    switch action {
      
    case HomeStateAction.emptyAction:
      break
      
      
    default: break
    }
    
    return newState
  }
}

extension HomeState {
  
  enum HomeStateAction: Action, Codable {
    case emptyAction
  }
}
