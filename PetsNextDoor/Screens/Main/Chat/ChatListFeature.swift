//
//  ChatListFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/10.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ChatListFeature: Reducer {
  
  @ObservableState
  struct State: Equatable {
    var tabIndex: Int = 0
  }
  
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case onTabIndexChange(Int)
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
        
      case .onTabIndexChange(let tabIndex):
        state.tabIndex = tabIndex
        return .none
        
      case .binding:
        return .none
      }
      return .none
    }
  }
}
