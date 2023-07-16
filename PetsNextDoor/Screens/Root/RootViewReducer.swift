//
//  RootViewReducer.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/16.
//

import Foundation

final class RootViewReducer: Reducer {

  struct State: Equatable {
    
  }
  
  enum Action {
    
  }
  
  enum Feedback {
    
  }
  
  enum Output: ObservableOutput {
    
  }
  
  func reduce(
    message: Message<Action, Feedback>,
    into state: inout State
  ) -> Effect<Feedback, Output> {
    
    return .none
  }
  
  
}
