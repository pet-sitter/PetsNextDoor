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
    var router: Router<Screens>.State = .init()
  }
  
  enum Action: Equatable {
    case viewWillAppear
    case didTapKakaoLogin
    case didTapGoogleLogin
    case didTapAppleLogin
    
    // Internal Cases
    
    case _routeAction(Router<Screens>.Action)
  }
  
  enum Screens: Equatable, ViewProvidable {

    case authenticatePhone(AuthenticateFeature.State)
    
    func createView() -> PresentableView {
      switch self {
      case .authenticatePhone(let state):
        
        return AuthenticatePhoneNumberViewController(
          store: .init(initialState: state, reducer: { AuthenticateFeature() })
        )
      }
    }
  }
  
  init() {
    
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
      case .viewWillAppear:
        return .none
      
      case .didTapGoogleLogin:
        state.isLoading = true
      
        return .run { send in
          let loginResult = await loginService.signInWithGoogle()
          
          switch loginResult {
          case let .success(isUserRegistrationNeeded, userRegisterModel):
            
            if isUserRegistrationNeeded, let userRegisterModel {
              await send(._routeAction(.pushScreen(.authenticatePhone(.init()), animated: true)))
            } else {
              // 곧바로 메인 화면으로 이동
            }
            
          case .failed(let reason):
            // ToastMessage 비슷한거 띄우기
            // 아래 코드는 임시
            print("❌ signInWithGoogle failed : \(reason)")
            await send(._routeAction(.pushScreen(.authenticatePhone(.init()), animated: true)))
            break
          }
        }
               


        
      case .didTapKakaoLogin:
        return .none
      
      default:
        return .none
      }
    }
    
  }
  
 

  
  
}
