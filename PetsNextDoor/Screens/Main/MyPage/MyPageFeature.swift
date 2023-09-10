//
//  MyPageFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/10.
//

import Foundation
import ComposableArchitecture

struct MyPageFeature: Reducer {
  
  struct State: Equatable {
    
  }
  
  enum Action: Equatable {
    
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      return .none
    }
  }
}
