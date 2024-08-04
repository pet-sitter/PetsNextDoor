//
//  LoginView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/22.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
  
  @State var store: StoreOf<LoginFeature>
  
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      contentView
    } destination: { store in
      switch store.state {
      case .setProfile:
        if let store = store.scope(state: \.setProfile, action: \.setProfile) {
          SetProfileView(store: store)
        }
        
      
        
        
//      case .selectEitherCatOrDog:
//        if let store = store.scope(state: \.selectEitherCatOrDog, action: \.selectEitherCatOrDog) {
//          SelectEitherCatOrDogView(store: store)
//        }
//        
//      case .addPet:
//        if let store = store.scope(state: \.addPet, action: \.addPet) {
//          AddPetView(store: store)
//        }
      }
    }
  }
  
  private var contentView: some View {
    VStack {
      Image(.login)
        .resizable()
        .frame(width: 200, height: 120)
      
      Spacer().frame(height: 140)
      
      HStack(spacing: 15) {
        
        Button(action: {
          store.send(.view(.didTapGoogleLogin))
        }, label: {
          Image(.googleLogin)
            .frame(width: 67, height: 67)
        })
        
        Button(action: {
          
        }, label: {
          Image(.kakaoLogin)
            .frame(width: 67, height: 67)
        })
        
        Button(action: {
          
        }, label: {
          Image(.appleLogin)
            .frame(width: 67, height: 67)
        })
      }
    }
  }
}

#Preview {
  LoginView(store: .init(initialState: .init(), reducer: { LoginFeature()}))
}
