//
//  HomeFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/08.
//

import Foundation
import ComposableArchitecture

struct HomeFeature: Reducer {
  
  struct State: Equatable {
    fileprivate var router: Router<PND.Destination>.State = .init()
    var urgentPostCardCellViewModels: [UrgentPostCardViewModel] = []
  }
  
  enum Action: Equatable {
    
    case viewDidLoad
    case didTapWritePostIcon
    case didTapUrgentPost(UrgentPostCardViewModel)
    
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
        for _ in 1..<10 {
          state.urgentPostCardCellViewModels.append(
            UrgentPostCardViewModel(
              postTitle: "돌봄 급히 구함",
              date: "2022-10-30",
              location: "반포동",
              cost: "시급 10,500원"
            )
          )
          
        }
        
        
        return .none
        
    
      case .didTapWritePostIcon:
        return .send(._routeAction(.pushScreen(.selectPet(state: .init()), animated: true)))
        
      case .didTapUrgentPost(let vm):
        return .send(._routeAction(.pushScreen(.urgentPostDetail(state: .init()), animated: true)))
    
        
      default:
        return .none
      }
    }
  }
}
