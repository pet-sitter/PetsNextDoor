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
      SwiftUI.List {
        ForEach(0..<10) { _ in
          ChatRoomView()
        }
      }
      .environment(\.defaultMinListRowHeight, 0)
      .listStyle(.plain)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          SegmentControlView_SwiftUI(
            selectedIndex: viewStore.binding(
              get: \.tabIndex,
              send: { .onTabIndexChange($0)}
            ),
            segmentTitles: ["채팅", "모임채팅"]
          )
          .padding(.leading, PND.Metrics.defaultSpacing)
        }
      }
    }
  }
}

#Preview {
  ChatListView(store: .init(initialState: .init(), reducer: { ChatListFeature() }))
}
