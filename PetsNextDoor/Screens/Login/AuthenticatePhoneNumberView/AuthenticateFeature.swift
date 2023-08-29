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
    var nextDestination: PND.Destination? = nil
    var userRegisterModel: PND.UserRegistrationModel
  
    init(userRegisterModel: PND.UserRegistrationModel) {
      self.userRegisterModel = userRegisterModel
    }
    
    //TODO: - : 아래 init 지우기
    init() {
      self.userRegisterModel = .init(email: "", fbProviderType: .google, fbUid: "", fullname: "")
    }
  }
  
  enum Action: Equatable {
    case didTapNextButton
    case setNextDestination(PND.Destination?)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      
			switch action {
			case .didTapNextButton:
        return .send(.setNextDestination(.setInitialProfile(SetProfileFeature.State(userRegisterModel: state.userRegisterModel))))
          
			case .setNextDestination(let destination):
				state.nextDestination = destination
				return .none
			}
    }
  }
}

