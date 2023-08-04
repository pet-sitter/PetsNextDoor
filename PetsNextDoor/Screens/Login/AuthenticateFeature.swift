//
//  AuthenticateFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/04.
//

import Foundation
import ComposableArchitecture

struct AuthenticateFeature: Reducer {

  struct State: Equatable {

    
    
    var nextDestination: PND.Destination? = nil
    


  }
  
  enum Action: Equatable {
    
    case didTapNextButton
    
    case setNextDestination(PND.Destination?)
  }
  
  func reduce(
    into state: inout State,
    action: Action
  ) -> EffectTask<Action> {
    return .none
  }
}
