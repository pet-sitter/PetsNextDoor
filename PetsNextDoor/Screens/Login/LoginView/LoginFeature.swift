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
  
  struct State: Equatable, RoutableState {
    var isLoading: Bool = false
    var router: Router<PND.Destination>.State = .init()
  }
  
  enum Action: Equatable, RoutableAction {
    case viewWillAppear
    case didTapKakaoLogin
    case didTapGoogleLogin
    case didTapAppleLogin
    
    // Internal Cases
    
    case _routeAction(Router<PND.Destination>.Action)
    case _setIsLoading(Bool)
  }
  
  init() {
    
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
      case .viewWillAppear:
        return .none
      
      case .didTapGoogleLogin:
        
//        return .send(._routeAction(.changeRootScreen(toScreen: .main(
//					homeState: HomeFeature.State(),
//					communityState: CommunityFeature.State(),
//					chatState: ChatListFeature.State(),
//					myPageState: MyPageFeature.State()
//        ))))
        
        // 임시코드임
//        return .send(._routeAction(.pushScreen(.authenticatePhoneNumber(.init(userRegisterModel: .init(email: "String", fbProviderType: .google, fbUid: "", fullname: "kevin", profileImageId: 1))))))

        state.isLoading = true
        
        return .run { send in
          let loginResult = await loginService.signInWithGoogle()
          
          switch loginResult {
          case let .success(isUserRegistrationNeeded, userRegisterModel):
            PNDLogger.default.info("isUserRegistrationNeeded: \(isUserRegistrationNeeded)")
            print("✅ userRegisterModel: \(userRegisterModel)")
            
            if isUserRegistrationNeeded, let userRegisterModel {
              await send(._routeAction(.pushScreen(.authenticatePhoneNumber(.init(userRegisterModel: userRegisterModel)), animated: true)))
            } else {
              await send(._routeAction(.changeRootScreen(toScreen: .main(
                homeState: HomeFeature.State(),
                communityState: CommunityFeature.State(),
                chatState: ChatListFeature.State(),
                myPageState: MyPageFeature.State()
              ))))
            }
            
          case .failed(let reason):
            // ToastMessage 비슷한거 띄우기
            // 아래 코드는 임시
            print("❌ signInWithGoogle failed : \(reason)")
//            await send(._routeAction(.pushScreen(.authenticatePhoneNumber(.init()), animated: true)))
            break
          }
          await send(._setIsLoading(false))
        }
        
      case .didTapKakaoLogin:
        return .none
        
      case ._setIsLoading(let isLoading):
        state.isLoading = isLoading
        return .none
      
      default:
        return .none
      }
    }
  }
}
