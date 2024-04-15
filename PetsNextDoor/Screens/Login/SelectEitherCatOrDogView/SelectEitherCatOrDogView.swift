//
//  SelectEitherCatOrDogView.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 11/29/23.
//

import SwiftUI
import ComposableArchitecture

struct SelectEitherCatOrDogView: View {
  
  @State var store: StoreOf<SelectEitherCatOrDogFeature>
	
	var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      contentView
    } destination: { store in
      switch store.state {
      case .addPet:
        if let store = store.scope(state: \.addPet, action: \.addPet) {
          AddPetView(store: store)
        }
      }
    }
	}
  
  private var contentView: some View {
    VStack(alignment: .leading) {
      
      Spacer()
        .frame(height: 20)
      
      Text("함께하는 반려동물을 선택해주세요")
        .font(.system(size: 20, weight: .semibold))
        .padding(.leading, PND.Metrics.defaultSpacing)
      
      HStack(alignment: .center) {
        Rectangle()
          .foregroundColor(store.selectedPetType == .cat ? PND.Colors.primary.asColor : .clear)
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
          store.send(.view(.onPetSelection(.cat)))
        }
        .clipped()
    
        
        Spacer()
        
        Rectangle()
          .foregroundColor(store.selectedPetType == .dog ? PND.Colors.primary.asColor : .clear)
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
          store.send(.view(.onPetSelection(.dog)))
        }
        .clipped()
      }
      .frame(height: 160)
      .padding()
      
      Spacer()
      
      BaseBottomButton_SwiftUI(
        title: "다음으로",
        isEnabled: $store.isBottomButtonEnabled
      )
      .onTapGesture {
        store.send(.view(.didTapBottomButton))
      }
    }
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button {
          store.send(.view(.onDismiss))
        } label: {
          Image(systemName: "xmark")
            .resizable()
            .frame(width: 15, height: 15)
        }
      }
    }
  }
}


#Preview {
  SelectEitherCatOrDogView(store: .init(initialState: .init(), reducer: { SelectEitherCatOrDogFeature() }))
}
