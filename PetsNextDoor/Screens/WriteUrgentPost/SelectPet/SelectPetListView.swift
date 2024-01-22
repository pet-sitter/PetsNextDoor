//
//  SelectPetListView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/18.
//

import SwiftUI
import ComposableArchitecture

struct SelectPetListView: View {
  
  let store: StoreOf<SelectPetFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView(.vertical) {
        VStack(alignment: .leading, spacing: 16) {
          
          Text("반려동물 선택")
            .modifier(HeaderTitleModifier())
          
          ForEach(viewStore.selectPetCellViewModels, id: \.self) { vm in
            SelectPetView(viewModel: vm)
              .onTapGesture {
                viewStore.send(.didSelectPet(vm))
              }
          }
          
          Spacer()
          
          BaseBottomButton_SwiftUI(
            title: "다음 단계로",
            isEnabled: viewStore.binding(
              get: \.isBottomButtonEnabled,
              send: { .setBottomButtonEnabled($0) })
          )
        }
      }
      .onAppear {
        viewStore.send(.viewDidLoad)
      }
    }
  }
}

#Preview {
  SelectPetListView(store: .init(initialState: .init(), reducer: SelectPetFeature()))
}
