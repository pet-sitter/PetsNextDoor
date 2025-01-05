//
//  ChatListView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/22.
//

import SwiftUI
import ComposableArchitecture

struct ChatListView: View {
  
  @State var store: StoreOf<ChatListFeature>
  
  var body: some View {
    VStack {
      
      topNavigationBarView
      
      Spacer().frame(height: 10)
      
      squareSegmentControlView
      
      Spacer().frame(height: 10)
      
      SwiftUI.List {
        ForEach(store.chatRoomViewModels, id: \.id) { vm in
          ChatRoomView(viewModel: vm)
            .onTapGesture { store.send(.onChatRoomTap) }
        }
      }
      .environment(\.defaultMinListRowHeight, 0)
      .listStyle(.plain)
      .refreshable {
        store.send(.onReload)
      }
    }
    .redacted(reason: store.isLoading ? .placeholder : [])
    .onAppear() {
      store.send(.onAppear)
    }
  }
  
  @ViewBuilder
  private var topNavigationBarView: some View {
    HStack {
    
      SegmentControlView_SwiftUI(
        selectedIndex: $store.tabIndex,
        segmentTitles: ["전체 채팅", "이벤트 채팅", "돌봄 채팅"]
      )
      .padding(.leading, PND.Metrics.defaultSpacing)
      
      Spacer()
      Spacer().frame(width: PND.Metrics.defaultSpacing)
      
    }
  }
  
  @ViewBuilder
  private var squareSegmentControlView: some View {
    HStack(spacing: 0) {
      
      RectangleSegmentControlView(
        selectedIndex: $store.eventChatIndex,
        segmentTitles: ["전체", "정기 이벤트", "단기 이벤트"]
      )
      .padding(.leading, PND.Metrics.defaultSpacing)
      
      Spacer()
      Spacer().frame(width: PND.Metrics.defaultSpacing)
    }
  }
}

#Preview {
  ChatListView(store: .init(initialState: .init(), reducer: { ChatListFeature() }))
}
