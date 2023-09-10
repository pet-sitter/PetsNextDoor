//
//  OutputStreamObservable.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import UIKit
import Combine



extension PND {
  
  enum Destination: Equatable, ViewProvidable {
    case main(homeState: HomeFeature.State, communityState: CommunityFeature.State, chatState: ChatListFeature.State, myPageState: MyPageFeature.State)
    case login(onWindow: UIWindow)
    case authenticatePhoneNumber(AuthenticateFeature.State)
    case setInitialProfile(SetProfileFeature.State)
    
    func createView() -> PresentableView {
      switch self {
        
      case let .main(homeState, communityState, chatState, myPageState):
        return MainTabBarController(
          homeStore:      .init(initialState: homeState, reducer: { HomeFeature() }),
          communityStore: .init(initialState: communityState, reducer: { CommunityFeature() }),
          chatListStore:  .init(initialState: chatState, reducer: { ChatListFeature() }),
          myPageStore:    .init(initialState: myPageState, reducer: { MyPageFeature() })
        )
        
      case .authenticatePhoneNumber(let state):
        return AuthenticatePhoneNumberViewController(
          store: .init(initialState: state, reducer: { AuthenticateFeature() })
        )
        
        
      case .setInitialProfile(let state):
        return SetProfileViewController(
          store: .init(initialState: state, reducer: { SetProfileFeature() })
        )
        
      default:
        // 아래 고치기
        fatalError()
        
      }
    }
  }
}

