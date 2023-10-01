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
    
    var router: Router<PND.Destination>.State = .init()
  
    init(userRegisterModel: PND.UserRegistrationModel) {
      self.userRegisterModel = userRegisterModel
    }
    
    //TODO: - : 아래 init 지우기
    init() {
      self.userRegisterModel = .init(email: "", fbProviderType: .google, fbUid: "", fullname: "")
    }
  }
  
  enum Action: Equatable {
    case didTapAuthenticateButton
    case didTapNextButton
    case didEndCountDownTimer
    case _routeAction(Router<PND.Destination>.Action)
  }
  
  var body: some Reducer<State, Action> {
    
    Scope(
      state: \.router,
      action: /Action._routeAction
    ) {
      Router<PND.Destination>()
    }
    
    Reduce { state, action in
      
			switch action {
        
      case .didTapAuthenticateButton:
        state.timerMilliseconds = 10000
        state.authenticateButtonIsEnabled = false
        return .none
        
			case .didTapNextButton:
        return .send(
          ._routeAction(
            .pushScreen(.setInitialProfile(.init(userRegisterModel: state.userRegisterModel)), animated: true)
          )
        )
        
      case .didEndCountDownTimer:
        state.authenticateButtonIsEnabled = true
        return .none

      default:
        return .none

			}
    }
  }
}

