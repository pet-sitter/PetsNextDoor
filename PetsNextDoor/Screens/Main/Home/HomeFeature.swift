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
  
  struct State: Equatable {
    
    var isLoadingInitialData: Bool = false
    
    var tabIndex: Int = 0
    var selectedCategory: SelectCategoryView_SwiftUI.Category = .onlyDogs
    
    
    var selectPetState: SelectPetFeature.State? = nil

    var urgentPostCardCellViewModels: [UrgentPostCardViewModel] = []
    
  }
  
  enum Action: Equatable {
    
    case onAppear

    case onTabIndexChange(Int)
    case onSelectedCategoryChange(SelectCategoryView_SwiftUI.Category)
    
    
    case setInitialUrgentPostCardCellVMs([UrgentPostCardViewModel])
    
    // Internal Cases
    
    case setIsLoading(Bool)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case .onAppear:
        if state.urgentPostCardCellViewModels.isEmpty == false { return .none }
        
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
                mainImageUrlString: "https://placedog.net/200/200?random",
                postTitle: $0.title,
                date: $0.date_end_at,
                location: "중곡동",
                cost: "10,500",
                postId: $0.id
              )
            }
        
          await send(.setInitialUrgentPostCardCellVMs(cellVMs))
          await send(.setIsLoading(false))
        }
        
      case .setInitialUrgentPostCardCellVMs(let cellVMs):
        state.urgentPostCardCellViewModels = cellVMs
        return .none
    
      case .onTabIndexChange(let index):
        state.tabIndex = index 
        return .none
        
      case .onSelectedCategoryChange(let category):
        state.selectedCategory = category
        return .none
        
      case .setIsLoading(let isLoading):
        state.isLoadingInitialData = isLoading
        return .none
      }
    }
  }
}
