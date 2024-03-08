//
//  SelectEitherCatOrDogView.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 11/29/23.
//

import SwiftUI
import ComposableArchitecture


struct SelectEitherCatOrDogView: View {
  
  let store: StoreOf<SelectEitherCatOrDogFeature>
	
	var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading) {
        
        Spacer()
          .frame(height: 20)
        
        Text("함께하는 반려동물을 선택해주세요")
          .font(.system(size: 20, weight: .semibold))
          .padding(.leading, PND.Metrics.defaultSpacing)
        
        HStack(alignment: .center) {
          Rectangle()
            .foregroundColor(viewStore.selectedPetType == .cat ? PND.Colors.primary.asColor : .clear)
          .background(Color(red: 0.95, green: 0.95, blue: 0.95))
          .cornerRadius(4)
          .overlay(alignment: .trailing, content: {
            Image("selectCat")
              .resizable()
              .scaledToFit()
          })
          .overlay {
            Text("고양이")
              .fontWeight(.bold)
              .padding(.top, -64)
              .padding(.leading, -70)
          }
          .onTapGesture {
            viewStore.send(.view(.onPetSelection(.cat)))
          }
          .clipped()
      
          
          Spacer()
          
          Rectangle()
            .foregroundColor(viewStore.selectedPetType == .dog ? PND.Colors.primary.asColor : .clear)
          .background(Color(red: 0.95, green: 0.95, blue: 0.95))
          .cornerRadius(4)
          .overlay(alignment: .trailing, content: {
            Image("selectDog")
            .resizable()
            .scaledToFit()
            .offset(x: 20, y: 30)
          })
          .overlay {
            Text("강아지")
              .fontWeight(.bold)
              .padding(.top, -64)
              .padding(.leading, -70)

          }
          .onTapGesture {
            viewStore.send(.view(.onPetSelection(.dog)))
          }
          .clipped()
        }
        .frame(height: 160)
        .padding()
        
        Spacer()
        
        BaseBottomButton_SwiftUI(
          title: "다음으로",
          isEnabled: viewStore.binding(
            get: \.isBottomButtonEnabled,
            send: { .view(.didTapBottomButton) }()
          )
        )
        .onTapGesture {
          viewStore.send(.view(.didTapBottomButton))
        }
      }
      .navigationDestination(
        store: store.scope(
          state: \.$addPetState,
          action: SelectEitherCatOrDogFeature.Action.addPetAction)
      ) { store in
        AddPetView(store: store)
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            viewStore.send(.view(.onDismiss))
          } label: {
            Image(systemName: "xmark")
              .resizable()
              .frame(width: 15, height: 15)
          }
        }
      }
    }
	}
}


#Preview {

  SelectEitherCatOrDogView(store: .init(initialState: .init(), reducer: { SelectEitherCatOrDogFeature() }))
}
