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
    
    case setIsLoadingInitialData(Bool)
  }
  

  init() {
    // 지금 문제 - init 이 여러번 불림 - 다른 화면 갔다와도 불림
    print("✅ INIT")
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case .onAppear:
        return .run { [state] send in
          
          await send(.setIsLoadingInitialData(true))
        
          
          let postModel = try await postService.getSOSPosts(
            authorId: nil,
            page: 1,
            size: 20,
            sortBy: "newest"
          )
        
          
          let cellVMs = postModel
            .items
            .compactMap { item -> UrgentPostCardViewModel in
              return UrgentPostCardViewModel(
                mainImageUrlString: item.media.first?.url ?? "",
                postTitle: item.title,
                date: item.date_end_at,
                location: "N/A",
                cost: item.reward,
                postId: item.id
              )
            }
        
          await send(.setIsLoadingInitialData(false))
          await send(.setInitialUrgentPostCardCellVMs(cellVMs))
        
        } catch: { error, send in
          print("❌ error fetching posts: \(error)")
        }
        
      case .setInitialUrgentPostCardCellVMs(let cellVMs):
        print("✅ existing data: \(state.urgentPostCardCellViewModels.count)")
        state.urgentPostCardCellViewModels = cellVMs
        return .none
    
      case .onTabIndexChange(let index):
        state.tabIndex = index 
        return .none
        
      case .onSelectedCategoryChange(let category):
        state.selectedCategory = category
        return .none
        
      case .setIsLoadingInitialData(let isLoading):
        state.isLoadingInitialData = isLoading
        return .none
      }
    }
  }
}
