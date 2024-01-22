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
    
    var isLoadingInitialData: Bool = false
    
    var tabIndex: Int = 0
    var selectedCategory: SelectCategoryView_SwiftUI.Category = .onlyDogs
    
    
    var selectPetState: SelectPetFeature.State? = nil
    
    
    
		var router: Router<PND.Destination>.State = .init()
    var urgentPostCardCellViewModels: [UrgentPostCardViewModel] = []
    
  }
  
  enum Action: Equatable, RoutableAction {
    
    case onAppear
    case didTapWritePostIcon
    case didTapUrgentPost(UrgentPostCardViewModel)
    case onTabIndexChange(Int)
    case onSelectedCategoryChange(SelectCategoryView_SwiftUI.Category)
    
    
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
        
      case .onAppear:
        return .run { send in
          
          await send(.setIsLoading(true))
          
          let postModel = try await postService.getSOSPosts(
            authorId: nil,
            page: 1,
            size: 20,
            sortBy: "newest"
          )
          
          let cellVMs = postModel
            .items
            .compactMap {
              UrgentPostCardViewModel(
                mainImageUrlString: "",
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
        return .none
        
    
      case .didTapWritePostIcon:
        print("✅ didTapWritePostIcon: ")
//        state.stateStack.append(SelectPetFeature.State())
        state.selectPetState = SelectPetFeature.State()
        return .send(._routeAction(.pushScreen(.selectPet(state: .init()), animated: true)))
        
      case .didTapUrgentPost(let vm):
    
        return .none
//        return .send(._routeAction(.pushScreen(.urgentPostDetail(state: .init()), animated: true)))
    
      case .onTabIndexChange(let index):
        state.tabIndex = index 
        return .none
        
      case .onSelectedCategoryChange(let category):
        state.selectedCategory = category
        return .none
        
      case .setIsLoading(let isLoading):
        state.isLoadingInitialData = isLoading
        return .none
        
      default:
        return .none
      }
    }
  }
}
