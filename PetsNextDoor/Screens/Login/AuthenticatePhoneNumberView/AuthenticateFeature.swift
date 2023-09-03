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
    
    var router: Router<Screens>.State = .init()
  
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
    
    case _routeAction(Router<Screens>.Action)
  }
  
  enum Screens: Equatable, ViewProvidable {
    
    case setProfile(SetProfileFeature.State)
    
    func createView() -> PresentableView {
      switch self {
      case .setProfile(let state):
        return SetProfileViewController(
          store: .init(initialState: state, reducer: { SetProfileFeature() })
        )
      }
    }
  }
  
  var body: some Reducer<State, Action> {
    
    Scope(
      state: \.router,
      action: /Action._routeAction
    ) {
      Router<Screens>()
    }
    
    Reduce { state, action in
      
			switch action {
			case .didTapNextButton:
        return .send(._routeAction(.pushScreen(.setProfile(.init(userRegisterModel: state.userRegisterModel)), animated: true)))

      default:
        return .none

			}
    }
  }
}

