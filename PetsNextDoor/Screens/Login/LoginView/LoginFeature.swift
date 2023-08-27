//
//  LoginFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/20.
//

import Foundation
import ComposableArchitecture
import Combine

struct LoginFeature: Reducer {
  
  @Dependency(\.loginService) private var loginService
  
  struct State: Equatable {
    var isLoading: Bool = false
    var nextDestination: PND.Destination? = nil
  }
  
  enum Action: Equatable {
    case viewWillAppear
    case didTapKakaoLogin
    case didTapGoogleLogin
    case didTapAppleLogin
    case setNextDestination(PND.Destination?)
    
    // Internal Cases
    case _setIsLoading(Bool)
  }
  
  init() {
    
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .viewWillAppear:
        return .none
        
      case ._setIsLoading(let isLoading):
        state.isLoading = isLoading
        return .none
        
      case .didTapGoogleLogin:
        return .run { send in
          await send(._setIsLoading(true))
          
          let loginResult = await loginService.signInWithGoogle()
          
          switch loginResult {
          case let .success(isUserRegistrationNeeded, userRegisterModel):
            
            if isUserRegistrationNeeded, let userRegisterModel {
              await send(.setNextDestination(
                .authenticatePhoneNumber(AuthenticateFeature.State(userRegisterModel: userRegisterModel)))
              )
            } else {
              // 곧바로 메인 화면으로 이동
            }
            
          case .failed(let reason):
            // ToastMessage 비슷한거 띄우기
            // 아래 코드는 임시
            print("❌ signInWithGoogle failed : \(reason)")
            await send(.setNextDestination(.authenticatePhoneNumber(.init(userRegisterModel: .init(email: "", fbProviderType: .google, fbUid: "", fullname: "")))))
            break
          }
          await send(._setIsLoading(false))
        }
        
      case .didTapKakaoLogin:
        return .run { send in
          await send(._setIsLoading(true))
          
          
          await send(._setIsLoading(false))
        }
        
      case .setNextDestination(let destination):
        state.isLoading = false
        state.nextDestination = destination
        return .none
        
      
      default:
        return .none
      }
    }
    
  }
  
 

  
  
}
