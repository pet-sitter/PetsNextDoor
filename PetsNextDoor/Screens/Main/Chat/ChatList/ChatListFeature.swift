//
//  ChatListFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/10.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ChatListFeature: Reducer {
  
  @Dependency(\.chatAPIService) var chatAPIService
  
  @ObservableState
  struct State: Equatable {
    var tabIndex: Int = 0
  }
  
  enum Action: Equatable, BindableAction {
    case onAppear
    case onTabIndexChange(Int)
    case onChatRoomTap
    case binding(BindingAction<State>)
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
        
      case .onAppear:
        return .run { send in
          
          let roomList = try await chatAPIService.getChatRooms()
          print("✅ roomList: \(roomList)")
           
        } catch: { error, send in
          
        }
        
      case .onTabIndexChange(let tabIndex):
        state.tabIndex = tabIndex
        return .none
        
      case .onChatRoomTap:
        
        return .none
        
      case .binding:
        return .none
      }
    }
  }
}
