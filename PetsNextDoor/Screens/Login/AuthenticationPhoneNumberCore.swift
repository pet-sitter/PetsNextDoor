//
//  AuthenticationPhoneNumberCore.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/20.
//

import Foundation
import ComposableArchitecture

struct AuthenticationPhoneNumberCore: ReducerProtocol {
  
  struct State: Equatable {
    var nextDestination: PND.Destination?
  }
  
  enum Action: Equatable {
    
  }
  
  func reduce(
    into state: inout State,
    action: Action
  ) -> EffectTask<Action> {
    
  }
  
}
