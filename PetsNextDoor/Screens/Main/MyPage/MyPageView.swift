//
//  MyPageView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/22.
//

import SwiftUI
import ComposableArchitecture

struct MyPageView: View {
  
  let store: StoreOf<MyPageFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in

    }
  }
}

#Preview {

  MyPageView(store: .init(initialState: .init(), reducer: { MyPageFeature() }))
}
