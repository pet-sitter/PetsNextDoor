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
      
      SwiftUI.List {
        ForEach(0..<1) { _ in
          ChatRoomView()
            .onTapGesture { store.send(.onChatRoomTap) }
        }
      }
      .environment(\.defaultMinListRowHeight, 0)
      .listStyle(.plain)
    }
    .onAppear() {
      store.send(.onAppear)
    }
  }
  
  private var topNavigationBarView: some View {
    HStack {
    
      SegmentControlView_SwiftUI(
        selectedIndex: $store.tabIndex,
        segmentTitles: ["전체 채팅", "이벤트 채팅", "돌봄 채팅"]
      )
      .padding(.leading, PND.Metrics.defaultSpacing)
      
      Spacer()
      
      Button(action: {

      }, label: {
        Image(.iconSetting)
          .resizable()
          .frame(width: 24, height: 24)
          .tint(PND.Colors.commonBlack.asColor)
      })
      
      Spacer().frame(width: PND.Metrics.defaultSpacing)
      
    }
  }
}

#Preview {
  ChatListView(store: .init(initialState: .init(), reducer: { ChatListFeature() }))
}
