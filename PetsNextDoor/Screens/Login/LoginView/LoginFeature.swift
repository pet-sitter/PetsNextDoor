//
//  LoginFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/20.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Combine

struct LoginFeature: Reducer {
  
  @Dependency(\.loginService) private var loginService
  
  struct State: Equatable {
    var isLoading: Bool = false
    
    var isLoggedIn: Bool = false
    
    @PresentationState var setProfileState: SetProfileFeature.State? = nil
  }
  
  enum Action: Equatable {
    case viewWillAppear
    case didTapKakaoLogin
    case didTapGoogleLogin
    case didTapAppleLogin
    
    case setIsLoggedIn(Bool)
    case setProfileState(PND.UserRegistrationModel)
    
    
    case setProfileAction(PresentationAction<SetProfileFeature.Action>)
    
    case _setIsLoading(Bool)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in

      switch action {
      case .viewWillAppear:
        return .none
      
      case .didTapGoogleLogin:
        state.isLoading = true
        
        return .run { send in
      
          let loginResult = await loginService.signInWithGoogle()
          
          switch loginResult {
            case let .success(isUserRegistrationNeeded, userRegisterModel):
//            await send(.setProfileState(.init(
//              email: "",
//              fbProviderType: .google,
//              fbUid: "123",
//              fullname: "Kevin",
//              profileImageId: 1)))
            if isUserRegistrationNeeded {     // 로그인 성공 - 자체 DB 회원가입 필요
              await send(.setProfileState(.init(
                email: "",
                fbProviderType: .google,
                fbUid: "123",
                fullname: "Kevin",
                profileImageId: 1)))
              
            } else {
              await send(.setIsLoggedIn(true))
            }
            
          case .failed(let reason):
            print("❌ signInWithGoogle failed : \(reason)")
            await MainActor.run {
              Toast.shared.present(title: .commonError, symbol: "xmark")
            }
          }
          
          await send(._setIsLoading(false))
        }
        
      case .didTapKakaoLogin:
        return .none
        
      case .didTapAppleLogin:
        return .none
        
      case ._setIsLoading(let isLoading):
        state.isLoading = isLoading
        return .none
        
      case .setProfileState(let userRegistrationModel):
        
        state.setProfileState = .init(userRegisterModel: userRegistrationModel)
        return .none
        
      case let .setIsLoggedIn(isLoggedIn):
        let window = UIApplication
          .shared
          .connectedScenes
          .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
          .first { $0.isKeyWindow }
        
        window?.rootViewController = UIHostingController(rootView: TabBarView().environmentObject(Router()))
        window?.makeKeyAndVisible()
        
        state.isLoggedIn = isLoggedIn
        return .none
        
      case .setProfileAction(.dismiss):
        state.setProfileState = nil
        return .none
        
      case .setProfileAction(.presented(_)):
        return .none
      }
    }
    .ifLet(\.$setProfileState, action: /Action.setProfileAction) { SetProfileFeature() }
  }
}
