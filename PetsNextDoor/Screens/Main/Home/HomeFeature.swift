//
//  HomeFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/08.
//

import Foundation
import ComposableArchitecture

struct HomeFeature: Reducer {
  
  @Dependency(\.sosPostService) var postService
  
  struct State: Equatable, RoutableState {
    
    var isLoading: Bool = false
    
		var router: Router<PND.Destination>.State = .init()
    @Pulse var urgentPostCardCellViewModels: [UrgentPostCardViewModel] = []
  }
  
  enum Action: Equatable, RoutableAction {
    
    case viewDidLoad
    case didTapWritePostIcon
    case didTapUrgentPost(UrgentPostCardViewModel)
    
    case setUrgentPostCardCellVMs([UrgentPostCardViewModel])
    
    // Internal Cases
    
    case setIsLoading(Bool)
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
        return .run { send in
          
          await send(.setIsLoading(true))
          
          let postModels = try await postService.getSOSPosts(
            authorId: nil,
            page: 1,
            size: 20,
            sortBy: "newest"
          )
          
          let cellVMs = postModels
            .items
            .compactMap {
              UrgentPostCardViewModel(
                postTitle: $0.title,
                date: $0.date_end_at,
                location: "중곡동",
                cost: "10,500"
              )
            }
        
          await send(.setUrgentPostCardCellVMs(cellVMs))
          await send(.setIsLoading(false))
        }
        
        
      case .setUrgentPostCardCellVMs(let cellVMs):
        state.urgentPostCardCellViewModels.append(contentsOf: cellVMs)
//        for _ in 1..<10 {
//          state.urgentPostCardCellViewModels.append(
//            UrgentPostCardViewModel(
//              postTitle: "돌봄 급히 구함",
//              date: "2022-10-30",
//              location: "반포동",
//              cost: "시급 10,500원"
//            )
//          )
//          
//        }
        return .none
        
    
      case .didTapWritePostIcon:
        return .send(._routeAction(.pushScreen(.selectPet(state: .init()), animated: true)))
        
      case .didTapUrgentPost(let vm):
        return .send(._routeAction(.pushScreen(.urgentPostDetail(state: .init()), animated: true)))
    
        
      case .setIsLoading(let isLoading):
        state.isLoading = isLoading
        return .none
        
      default:
        return .none
      }
    }
  }
}
