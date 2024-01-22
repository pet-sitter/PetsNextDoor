//
//  ChatListView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/22.
//

import SwiftUI
import ComposableArchitecture


struct ChatListView: View {
  
  let store: StoreOf<ChatListFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Text("chat")
      
    }
  }
}

#Preview {
  ChatListView(store: .init(initialState: .init(), reducer: { ChatListFeature() }))
}
