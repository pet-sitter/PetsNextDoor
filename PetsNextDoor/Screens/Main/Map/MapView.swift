//
//  MapView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/02/19.
//

import SwiftUI
import ComposableArchitecture

struct MapFeature: Reducer {
  
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

struct MapView: View {
  
  let store: StoreOf<MapFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        topNavigationBar
        
        Spacer()
      }
    }
  }
  
  
  @ViewBuilder
  private var topNavigationBar: some View {
    VStack(spacing: 0) {
     
      HStack {
        DefaultSpacer(axis: .horizontal)
        Text("지도")
          .font(.system(size: 20, weight: .bold))
        
        Spacer()
      }

      Spacer().frame(height: 9)
      
      
      RoundedRectangle(cornerRadius: 4)
        .frame(height: 40)
        .padding(.horizontal, PND.Metrics.defaultSpacing)
        .foregroundStyle(PND.DS.gray20)
        .overlay(alignment: .leading) {
          HStack(spacing: 8) {
            Image(.iconSearch)
              .size(16)
            
            Text("놀이이벤트를 검색해보세요")
              .foregroundStyle(UIColor(hex: "#9E9E9E").asColor)
              .font(.system(size: 16))
          }
          .padding(.leading, PND.Metrics.defaultSpacing + 12)
        }
    }
  }
}

#Preview {
  MapView(store: .init(initialState: .init(), reducer: { MapFeature() }))
}
