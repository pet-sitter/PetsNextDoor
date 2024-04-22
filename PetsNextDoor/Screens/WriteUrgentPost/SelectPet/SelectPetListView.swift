//
//  SelectPetListView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/18.
//

import SwiftUI
import ComposableArchitecture

struct SelectPetListView: View {
  
  let store: StoreOf<SelectPetListFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: 0) {
        
        Spacer().frame(height: 24)
        
        ScrollView(.vertical) {
            Text("돌봄이 필요한 반려동물 선택")
              .modifier(HeaderTitleModifier())
            
            Spacer().frame(height: 16)
            
            ForEach(viewStore.selectPetCellViewModels, id: \.self) { vm in
              SelectPetView(viewModel: vm, onDeleteButtonTapped: nil)
                .onTapGesture {
                  viewStore.send(.didSelectPet(vm))
                }
              
              Spacer().frame(height: 16)
              
            }
        }
        
        Spacer()

        BaseBottomButton_SwiftUI(
          title: "다음 단계로",
          isEnabled: viewStore.binding(
            get: \.isBottomButtonEnabled,
            send: { .setBottomButtonEnabled($0) })
        )
        .onTapGesture {
          viewStore.send(.onBottomButtonTap)
        }
      }
      .onAppear {
        viewStore.send(.viewDidLoad)
      }
    }
  }
}

#Preview {
  SelectPetListView(store: .init(initialState: .init(), reducer: { SelectPetListFeature() }))
}
