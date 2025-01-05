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
    var isLoading: Bool = false
    var tabIndex: Int = 0
    var eventChatIndex: Int = 0
    var chatRoomViewModels: [ChatRoomView.ViewModel] = []
    
  }
  
  enum Action: Equatable, BindableAction {
    case onAppear
    case onReload
    case setChatRoomViewModels(PND.ChatListModel)
    case setIsLoading(Bool)
    case onChatRoomTap
    case binding(BindingAction<State>)
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
        
      case .onAppear:
        return .run { [state] send in
          
          guard state.chatRoomViewModels.isEmpty else { return }
          
          await send(.setIsLoading(true))
          
          let roomListModel = try await chatAPIService.getChatRooms()
          
          await send(.setChatRoomViewModels(roomListModel))
          await send(.setIsLoading(false))
           
        } catch: { error, send in
          await send(.setIsLoading(false))
        }
        
      case .onReload:
        return .run { send in
          let roomListModel = try await chatAPIService.getChatRooms()
          await send(.setChatRoomViewModels(roomListModel))
        }
        
      case .setChatRoomViewModels(let roomListModel):
        state.chatRoomViewModels = roomListModel.items.map { model -> ChatRoomView.ViewModel in
          ChatRoomView.ViewModel(
            id: model.id,
            roomName: model.roomName,
            roomType: .eventChat(.recurring),
            latestMessage: "최신 메시지",
            unreadMessagesCount: 1,
            maxParticipantCount: 10,
            currentParticipantCount: 4,
            joinedUsers: []
            )
        }
        return .none
        
      case .setIsLoading(let isLoading):
        state.isLoading = isLoading
        return .none
        
      case .onChatRoomTap:
        
        return .none
        
      case .binding:
        return .none
      }
    }
  }
}
