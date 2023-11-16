//
//  CommunityFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/10.
//

import Foundation
import ComposableArchitecture

struct CommunityFeature: Reducer {
  
  struct State: Equatable {
    fileprivate var router: Router<PND.Destination>.State = .init()
    
  }
  
  enum Action: Equatable {
    case viewDidLoad
    case didTapAddButton
    

    // Internal Cases
    case _routeAction(Router<PND.Destination>.Action)
  }
  
  var body: some Reducer<State, Action> {
    
    Scope(
      state: \.router,
      action: /Action._routeAction
    ) {
      Router<PND.Destination>()
    }
    
    Reduce { state, action in
      switch action {
        
      case .viewDidLoad:
        
        return .none

        
      case .didTapAddButton:
        
        return .none
        
      default:
        return .none
      }
    }
  }
}
