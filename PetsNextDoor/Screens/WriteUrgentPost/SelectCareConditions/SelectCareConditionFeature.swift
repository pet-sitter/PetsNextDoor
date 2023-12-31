//
//  SelectCareConditionFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/07.
//

import Foundation
import ComposableArchitecture

struct SelectCareConditionFeature: Reducer {
  
  struct State: Equatable {
    var isBottomButtonEnabled: Bool = true
    
    fileprivate var router: Router<PND.Destination>.State = .init()
  }
  
  enum Action: Equatable {
    case viewDidLoad
    case didTapBottomButton
    
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
        
      case .didTapBottomButton:
        return .send(._routeAction(.pushScreen(.selectOtherRequirements(state: .init()), animated: true)))
        
      default:
        return .none
      }

    }
  }
}
