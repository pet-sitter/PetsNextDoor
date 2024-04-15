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

@Reducer
struct LoginNavigationPath {
  
  @ObservableState
  enum State: Equatable {
    case setProfile(SetProfileFeature.State)
  }
  
  enum Action: Equatable {
    case setProfile(SetProfileFeature.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.setProfile, action: \.setProfile) { SetProfileFeature() }
  }
}

@Reducer
struct LoginFeature: Reducer {
  
  @Dependency(\.loginService) private var loginService
  
  @ObservableState
  struct State: Equatable {
    var isLoading: Bool = false
    
    var isLoggedIn: Bool = false
    
     var setProfileState: SetProfileFeature.State? = nil
    
    var path: StackState<LoginNavigationPath.State> = .init()
  }
  
  enum Action: RestrictiveAction, BindableAction {
    
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
      case moveToSetProfileView(PND.UserRegistrationModel)
    }
  
    case view(ViewAction)
    case delegate(DelegateAction)
    case `internal`(InternalAction)
    
    case binding(BindingAction<State>)
    case path(StackAction<LoginNavigationPath.State, LoginNavigationPath.Action>)
  

    case setProfileAction(PresentationAction<SetProfileFeature.Action>)
  }
  
  var body: some Reducer<State, Action> {
    
    BindingReducer()
    
    loginNavigationReducer
    
    Reduce { state, action in

      switch action {
      case .view(.viewWillAppear):
        return .none
      
      case .view(.didTapGoogleLogin):
        state.isLoading = true
        
        return .run { send in
//          await send(.setIsLoggedIn(true))
//          await send(.delegate(.moveToSetProfileView(.init(
//            email: "",
//            fbProviderType: .google,
//            fbUid: "123",
//            fullname: "Kevin"))))

          
          let loginResult = await loginService.signInWithGoogle()

          switch loginResult {
            case let .success(isUserRegistrationNeeded, userRegisterModel):

            if isUserRegistrationNeeded, let userRegisterModel {     // 구글 로그인 성공, but 자체 PND 서버 회원가입 필요
              await send(.delegate(.moveToSetProfileView(userRegisterModel)))
              
              
            } else {
              await send(.internal(.setIsLoggedIn(true)))
            }
            
          case .failed(let reason):
            print("❌ signInWithGoogle failed : \(reason)")
            await MainActor.run {
              Toast.shared.present(title: .commonError, symbol: "xmark")
            }
          }
          
          await send(.internal(.setIsLoading(false)))
        }
        
      case .view(.didTapKakaoLogin):
        return .none
        
      case .view(.didTapAppleLogin):
        return .none
        
      case .internal(.setIsLoading(let isLoading)):
        state.isLoading = isLoading
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
        
      case .binding(_):
        return .none
      case .path(_):
        return .none
      }
    }
  }
  
  var loginNavigationReducer: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case .delegate(.moveToSetProfileView(let registrationModel)):
        state.path.append(.setProfile(SetProfileFeature.State(userRegisterModel: registrationModel)))
        return .none
        
      case let .path(action):
         
        switch action {
          
     
        
        default:
          return .none
        }
        
        
      default:
        return .none
      }
    }
    .forEach(\.path, action: /Action.path) {
      LoginNavigationPath()
    }
  }
}
