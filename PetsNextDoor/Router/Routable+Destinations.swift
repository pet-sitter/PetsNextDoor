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
    
    // 메인
    case main(homeState: HomeFeature.State, communityState: CommunityFeature.State, chatState: ChatListFeature.State, myPageState: MyPageFeature.State)
    
    // 돌봄급구 글쓰기
    case selectPet(state: SelectPetFeature.State)
    case selectCareCondition(state: SelectCareConditionFeature.State)
    
    // 로그인 / 회원가입 화면
    case login(onWindow: UIWindow)
    case authenticatePhoneNumber(AuthenticateFeature.State)
    case setInitialProfile(SetProfileFeature.State)
    
    func createView() -> PresentableView {
      switch self {
        
        // 메인
        
      case let .main(homeState, communityState, chatState, myPageState):
        return MainTabBarController(
          homeStore:      .init(initialState: homeState, reducer: { HomeFeature() }),
          communityStore: .init(initialState: communityState, reducer: { CommunityFeature() }),
          chatListStore:  .init(initialState: chatState, reducer: { ChatListFeature() }),
          myPageStore:    .init(initialState: myPageState, reducer: { MyPageFeature() })
        )
        
        // 돌봄급구 글쓰기 Flow
      case .selectPet(let state):
        return SelectPetViewController(
          store: .init(initialState: state, reducer: { SelectPetFeature() })
        )
        
      case .selectCareCondition(let state):
        return SelectCareConditionsViewController(store: .init(initialState: state, reducer: SelectCareConditionFeature() ))
        
        // 로그인 / 회원가입 화면
        
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

