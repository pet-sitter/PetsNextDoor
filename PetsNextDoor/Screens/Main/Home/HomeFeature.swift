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
  @Dependency(\.petService) var petService
  @Dependency(\.userDataCenter) var userDataCenter
  
  @ObservableState
  struct State: Equatable {
    var tabIndex: Int                         = 0
    var selectedSortOption: PND.SortOption    = .newest
    var selectedFilterOption: PND.FilterType  = .onlyDogs
    var isLoadingInitialData: Bool            = false
    
    var urgentPostCardCellViewModels: [UrgentPostCardViewModel] = []
    
    var emptyContentMessage: String? = nil
  
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
      case fetchMyPets
      case setInitialUrgentPostCardCellVMs([UrgentPostCardViewModel])
      case setUserHasPetsRegistered(Bool)
      case setIsLoadingInitialData(Bool)
      case setEmptyContentMessage(String)
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
        
        return .run { send in
          await send(.internal(.setIsLoadingInitialData(true)))
          await send(.internal(.fetchSOSPosts(page: 1)))
          await send(.internal(.fetchMyPets))
          await send(.internal(.setIsLoadingInitialData(false)))
          
        } catch: { error, send in
          print("❌ error fetching posts: \(error)")
        }
        
      case .view(.onSelectWritePostIcon):
        return .run { send in
          
          let userHasPetsRegistered: Bool = await userDataCenter.hasPetsRegistered
          
          if userHasPetsRegistered {
            await send(.delegate(.pushToSelectPetListView))
          } else {
            
            // 알림 띄워야함 - 반려동물 등록 유도 알림
            Toast.shared.present(title: "반려동물을 먼저 등록해주세요", symbolType: .info)
          }
        }
    
      case .view(.onTabIndexChange(let index)):
        state.tabIndex = index
        return .none
        
      case .view(.onSelectedFilterOptionChange(let filterType)):
        state.selectedFilterOption = filterType
        state.emptyContentMessage  = nil
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
          
          if postModel.items.isEmpty {
            await send(.internal(.setEmptyContentMessage("아직 작성된 글이 없어요.\n첫번째 글을 작성해보세요!")))
            return
          }
          
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
        
      case .internal(.fetchMyPets):
        return .run { send in
          
          let myPets = try await petService.getMyPets().pets
          
          await send(.internal(.setUserHasPetsRegistered(myPets.isEmpty ? false : true)))
          
        } catch: { error, _ in
          PNDLogger.network.error("Failed fetching my pets with error: \(error)")
        }
        
      case .internal(.setInitialUrgentPostCardCellVMs(let cellVMs)):
        state.urgentPostCardCellViewModels = cellVMs
        return .none
        
      case .internal(.setUserHasPetsRegistered(let hasPets)):
        return .run { _ in
          await userDataCenter.setUserHasPetsRegistered(to: hasPets)
        }
    
      case .internal(.setIsLoadingInitialData(let isLoading)):
        state.isLoadingInitialData = isLoading
        return .none
        
      case .internal(.setEmptyContentMessage(let message)):
        state.emptyContentMessage = message
        return .none
        
      case .delegate(_):
        return .none
      
      case .binding(_):
        return .none
      }
    }
  }
}
