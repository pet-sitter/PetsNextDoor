//
//  MyActivityFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/05/15.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct MyActivityFeature: Reducer {
  
  @Dependency(\.sosPostService) var postService // 추후 변경 필요

  @ObservableState
  struct State: Equatable {
    var selectedIndex: Int = 0
    var urgentPostCardCellVMs: [UrgentPostCardViewModel] = []
    var emptyContentMessage: String? = nil
  }
  
  enum Action: Equatable, BindableAction {
    
    case onAppear
    case setUrgentPostCardCellVMs([UrgentPostCardViewModel])
		case onUrgentPostTap(postId: Int)
    
    case setEmptyContentMessage(String)
		
    case binding(BindingAction<State>)
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        switch state.selectedIndex {
        case 0, 1, 2: 			// 추후 변경
          return .run { send in
            
            let posts = try await postService.getSOSPosts(
              authorId: nil,
              page: 1,
              size: 20,
							sortBy: PND.SortOption.newest.rawValue,
							filterType: .all
            )
            
            if posts.items.isEmpty {
              await send(.setEmptyContentMessage("아직 작성하신 글이 없어요."))
              return
            }
            
            let cellVMs = posts
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
            
            await send(.setUrgentPostCardCellVMs(cellVMs))
            
            
          } catch: { error, send in
            Toast.shared.presentCommonError()
          }
          
        default: return .none
        }
        
      case .setUrgentPostCardCellVMs(let cellVMs):
        state.urgentPostCardCellVMs = cellVMs
        return .none
				
			case .onUrgentPostTap:
				return .none

		
      case .setEmptyContentMessage(let message):
        state.emptyContentMessage = message
        return .none
        
      case .binding:
        return .none
      }
    }
  }
}

struct MyActivityView: View {
  
  @State var store: StoreOf<MyActivityFeature>
  
  var body: some View {
    ScrollView(.vertical) {
      
      SegmentButtonControlView(
        selectedIndex: $store.selectedIndex,
        buttonTitles: ["돌봄급구", "돌봄메이트", "후기"]
      )
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, PND.Metrics.defaultSpacing)
      
      LazyVStack(spacing: 0) {
        ForEach(store.urgentPostCardCellVMs, id: \.postId) { vm in
            UrgentPostCardView_SwiftUI(viewModel: vm)
						.onTapGesture {
							store.send(.onUrgentPostTap(postId: vm.postId))
						}
        }
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
}

