//
//  LoginView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/22.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
  
  let store: StoreOf<LoginFeature>
  
  @EnvironmentObject var router: Router
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        
        Image(R.image.loginImage)
          .resizable()
          .frame(width: 200, height: 120)
        
        Spacer().frame(height: 140)
        
        HStack(spacing: 15) {
          
          Button(action: {
            viewStore.send(.view(.didTapGoogleLogin))
          }, label: {
            Image(R.image.googleLogin)
              .frame(width: 67, height: 67)
          })
          
          Button(action: {
            
          }, label: {
            Image(R.image.kakaoLogin)
              .frame(width: 67, height: 67)
          })
          
          Button(action: {
            
          }, label: {
            Image(R.image.appleLogin)
              .frame(width: 67, height: 67)
          })
        }
      }
      .navigationDestination(
        store: store.scope(
          state: \.$setProfileState,
          action: LoginFeature.Action.setProfileAction
        )
      ) { SetProfileView(store: $0) }
    }
  }
}

#Preview {
  LoginView(store: .init(initialState: .init(), reducer: { LoginFeature()}))
}
