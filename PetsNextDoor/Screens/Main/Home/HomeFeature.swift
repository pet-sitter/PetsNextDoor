//
//  HomeFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/08.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeFeature: Reducer {
  
  @Dependency(\.sosPostService) var postService
  
  @ObservableState
  struct State: Equatable {
    
    var isLoadingInitialData: Bool = false
    
    var tabIndex: Int = 0
    var selectedFilterOption: PND.FilterType  = .onlyDogs
    var selectedSortOption: PND.SortOption    = .newest
    
    var selectPetState: SelectPetListFeature.State? = nil

    var urgentPostCardCellViewModels: [UrgentPostCardViewModel] = []
    
    fileprivate var page: Int = 1
    

  }
  
  enum Action: RestrictiveAction, BindableAction {
    
    enum ViewAction: Equatable {
      case onAppear
      case onTabIndexChange(Int)
      case onSelectWritePostIcon
      case onSelectedFilterOptionChange(PND.FilterType)
      case onSelectedSortOptionChange(PND.SortOption)
      case onUrgentPostTap(postId: Int)
    }
  
    enum InternalAction: Equatable {
      case fetchSOSPosts(page: Int)
      case setInitialUrgentPostCardCellVMs([UrgentPostCardViewModel])
      case setIsLoadingInitialData(Bool)
    }
    
    enum DelegateAction: Equatable {
      case pushToSelectPetListView
      case pushToUrgentPostDetailView(postId: Int)
    }
    
    case view(ViewAction)
    case delegate(DelegateAction)
    case `internal`(InternalAction)
    case binding(BindingAction<State>)
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {

      case .view(.onAppear):
        guard state.urgentPostCardCellViewModels.isEmpty == false else { return .none }
        
        return .run { [state] send in
          await send(.internal(.setIsLoadingInitialData(true)))
          await send(.internal(.fetchSOSPosts(page: 1)))
          await send(.internal(.setIsLoadingInitialData(false)))
          
        } catch: { error, send in
          print("❌ error fetching posts: \(error)")
        }
        
      case .view(.onSelectWritePostIcon):
        return .send(.delegate(.pushToSelectPetListView))
    
      case .view(.onTabIndexChange(let index)):
        state.tabIndex = index
        return .none
        
      case .view(.onSelectedFilterOptionChange(let filterType)):
        state.selectedFilterOption          = filterType
        state.urgentPostCardCellViewModels  = []
        
        return .run { send in
          await send(.internal(.setIsLoadingInitialData(true)))
          await send(.internal(.fetchSOSPosts(page: 1)))
          await send(.internal(.setIsLoadingInitialData(false)))
        }
        

        
      case .view(.onSelectedSortOptionChange(let sortOption)):
        state.selectedSortOption            = sortOption
        state.urgentPostCardCellViewModels  = []
        
        return .run { send in
          await send(.internal(.setIsLoadingInitialData(true)))
          await send(.internal(.fetchSOSPosts(page: 1)))
          await send(.internal(.setIsLoadingInitialData(false)))
        }
        
      case .view(.onUrgentPostTap(let postId)):
        return .send(.delegate(.pushToUrgentPostDetailView(postId: postId)))
        
      case .internal(.fetchSOSPosts(let page)):
        return .run { [state] send in
          
          let postModel = try await postService.getSOSPosts(
            authorId: nil,
            page: page,
            size: 20,
            sortBy: state.selectedFilterOption.rawValue,
            filterType: state.selectedFilterOption
          )
          
          let cellVMs = postModel
            .items
            .compactMap { item -> UrgentPostCardViewModel in
              return UrgentPostCardViewModel(
                mainImageUrlString: item.media.first?.url ?? "",
                postTitle: item.title,
                date: "N/A",
                location: "N/A",
                cost: item.reward,
                postId: item.id
              )
            }
          
          await send(.internal(.setInitialUrgentPostCardCellVMs(cellVMs)))
          
        } catch: { error, send in
          Toast.shared.presentCommonError()
        }
        
      case .internal(.setInitialUrgentPostCardCellVMs(let cellVMs)):
        state.urgentPostCardCellViewModels = cellVMs
        return .none
    
      case .internal(.setIsLoadingInitialData(let isLoading)):
        state.isLoadingInitialData = isLoading
        return .none
        
      case .delegate(_):
        return .none
      
      case .binding(_):
        return .none
      }
    }
  }
}
