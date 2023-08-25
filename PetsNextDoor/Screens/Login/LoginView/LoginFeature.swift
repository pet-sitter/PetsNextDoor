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
    case setIsLoading(Bool)
  }
  
  init() {
    
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .viewWillAppear:
        return .none
        
      case .setIsLoading(let isLoading):
        state.isLoading = isLoading
        return .none
        
      case .didTapGoogleLogin:
        return .run { send in
          await send(.setIsLoading(true))
          
          let loginResult = await loginService.signInWithGoogle()
          
          switch loginResult {
          case .success(let isUserRegistrationNeeded):
            
            if isUserRegistrationNeeded {
              await send(.setNextDestination(.authenticatePhoneNumber))
            } else {
              
            }
            
          case .failed(let reason):
            // ToastMessage 비슷한거 띄우기
            // 임시
            await send(.setNextDestination(.authenticatePhoneNumber))
            break
          }
          await send(.setIsLoading(false))
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
