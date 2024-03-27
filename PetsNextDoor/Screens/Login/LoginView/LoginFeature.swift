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
//          await send(.setIsLoggedIn(true))
//          await send(.setProfileState(.init(
//            email: "",
//            fbProviderType: .google,
//            fbUid: "123",
//            fullname: "Kevin",
//            profileImageId: 1)))
//      
          let loginResult = await loginService.signInWithGoogle()
//          
          switch loginResult {
            case let .success(isUserRegistrationNeeded, userRegisterModel):

            if isUserRegistrationNeeded, let userRegisterModel {     // 구글 로그인 성공, but 자체 PND 서버 회원가입 필요
              await send(.setProfileState(userRegisterModel))
              
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
        Router.changeRootViewToHomeView()
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
