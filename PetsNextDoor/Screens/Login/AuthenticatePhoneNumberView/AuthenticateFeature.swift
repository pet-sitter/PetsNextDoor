//
//  AuthenticateFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/04.
//

import Foundation
import ComposableArchitecture

struct AuthenticateFeature: Reducer {

  struct State: Equatable {
    var userRegisterModel: PND.UserRegistrationModel
    var timerMilliseconds: Int? = nil
    var authenticateButtonIsEnabled: Bool = true 
    
    init(userRegisterModel: PND.UserRegistrationModel) {
      self.userRegisterModel = userRegisterModel
    }
  }
  
  enum Action: Equatable {
    case didTapAuthenticateButton
    case didTapNextButton
    case didEndCountDownTimer
  }
  
  var body: some Reducer<State, Action> {
    
    Reduce { state, action in
      
			switch action {
        
      case .didTapAuthenticateButton:
        state.timerMilliseconds = 10000
        state.authenticateButtonIsEnabled = false
        return .none
        
			case .didTapNextButton:
        return .none 
//        return .send(
//          ._routeAction(
//            .pushScreen(.setInitialProfile(.init(userRegisterModel: state.userRegisterModel)), animated: true)
//          )
//        )
        
      case .didEndCountDownTimer:
        state.authenticateButtonIsEnabled = true
        return .none

      default:
        return .none

			}
    }
  }
}

