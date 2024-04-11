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
  
  enum Action: RestrictiveAction {
    
    enum ViewAction: Equatable {
      case viewWillAppear
      case didTapKakaoLogin
      case didTapGoogleLogin
      case didTapAppleLogin
    }
    
    enum InternalAction: Equatable {
      case setIsLoggedIn(Bool)
      case setIsLoading(Bool)
    }
    
    enum DelegateAction: Equatable {
      case moveToMainTabBarView
    }
  
    case view(ViewAction)
    case delegate(DelegateAction)
    case `internal`(InternalAction)
  
    case setProfileState(PND.UserRegistrationModel)
    case setProfileAction(PresentationAction<SetProfileFeature.Action>)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in

      switch action {
      case .view(.viewWillAppear):
        return .none
      
      case .view(.didTapGoogleLogin):
        state.isLoading = true
        
        return .run { send in
//          await send(.setIsLoggedIn(true))
          await send(.setProfileState(.init(
            email: "",
            fbProviderType: .google,
            fbUid: "123",
            fullname: "Kevin")))
          
//          let loginResult = await loginService.signInWithGoogle()
//
//          switch loginResult {
//            case let .success(isUserRegistrationNeeded, userRegisterModel):
//
//            if isUserRegistrationNeeded, let userRegisterModel {     // 구글 로그인 성공, but 자체 PND 서버 회원가입 필요
//              await send(.setProfileState(userRegisterModel))
//              
//            } else {
//              await send(.setIsLoggedIn(true))
//            }
//            
//          case .failed(let reason):
//            print("❌ signInWithGoogle failed : \(reason)")
//            await MainActor.run {
//              Toast.shared.present(title: .commonError, symbol: "xmark")
//            }
//          }
          
          await send(.internal(.setIsLoading(false)))
        }
        
      case .view(.didTapKakaoLogin):
        return .none
        
      case .view(.didTapAppleLogin):
        return .none
        
      case .internal(.setIsLoading(let isLoading)):
        state.isLoading = isLoading
        return .none
        
      case .setProfileState(let userRegistrationModel):
        
        state.setProfileState = .init(userRegisterModel: userRegistrationModel)
        return .none
        
      case let .internal(.setIsLoggedIn(isLoggedIn)):
        state.isLoggedIn = isLoggedIn
        return .send(.delegate(.moveToMainTabBarView))
        
      case .delegate:
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
