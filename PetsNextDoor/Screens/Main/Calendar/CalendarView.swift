//
//  CalendarView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/02/19.
//

import SwiftUI
import ComposableArchitecture

struct CalendarFeature: Reducer {
  
  struct State: Equatable {
    
  }
  
  enum Action: Equatable {
    
  }
  
  var body: some Reducer<State,Action> {
    Reduce { state, action in
      return .none
    }
  }
}

struct CalendarView: View {
  
  let store: StoreOf<CalendarFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Text("Calendar")
    }
  }
}

#Preview {
  CalendarView(store: .init(initialState: .init(), reducer: { CalendarFeature() }))
}
