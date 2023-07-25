//
//  LoginFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/20.
//

import Foundation
import ComposableArchitecture

struct LoginFeature: ReducerProtocol {
  
  struct State: Equatable {
    var nextDestination: PND.Destination?
  }
  
  enum Action: Equatable {
		
		case viewWillAppear

    case didTapKakaoLogin
    case didTapGoogleLogin
    case didTapAppleLogin
    
    case _setNextDestination(PND.Destination)
  }
  
  init() {
    
  }
  
  @Dependency(\.loginService) private var loginService
  
  func reduce(
    into state: inout State,
    action: Action
  ) -> EffectTask<Action> {
    
    switch action {
			
		case .viewWillAppear:
			state.nextDestination = nil
			return .none
    
    case .didTapGoogleLogin:
      return .run { send in
        let loginResult = await loginService.signInWithGoogle()
        
        switch loginResult {
        case .success(let isUserRegistrationNeeded):
          if isUserRegistrationNeeded {
            await send(._setNextDestination(.authenticatePhoneNumber))
          } else {
//            await send(._setNextDestination(.main(onWindow: \)))
            fatalError()
          }
//          await send(._setUserRegistrationIsNeeded(true))
          
        case .failed(let reason):
          print("❌ failed logging in: \(reason)")
        }
      }
      
    case ._setNextDestination(let destination):
			
      state.nextDestination = destination
      return .none
    
    default:
      return .none
    }
  }
  
  
}
