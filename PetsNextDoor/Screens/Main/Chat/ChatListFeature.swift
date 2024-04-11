//
//  ChatListFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/10.
//

import Foundation
import ComposableArchitecture

struct ChatListFeature: Reducer {
  
  struct State: Equatable {
    var tabIndex: Int = 0
  }
  
  enum Action: Equatable {
    case onTabIndexChange(Int)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      return .none
    }
  }
}
