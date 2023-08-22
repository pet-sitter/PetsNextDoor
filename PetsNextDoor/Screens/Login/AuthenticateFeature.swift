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

    
    var entity: [String] = []
    
    var nextDestination: PND.Destination? = nil
    
 
  }
  
  enum Action: Equatable {
    
    case didTapNextButton
    
    case setNextDestination(PND.Destination?)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      
			switch action {
			case .didTapNextButton:
				return .send(.setNextDestination(.setInitialProfile))
				
			case .setNextDestination(let destination):
				state.nextDestination = destination
				return .none
			}
    }
  }
}

