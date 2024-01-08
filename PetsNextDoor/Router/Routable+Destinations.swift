//
//  Destination.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import UIKit
import Combine
import SwiftUI

extension PND {
  
  enum Destination: Equatable, ViewProvidable {
    
    // 메인
    case main(homeState: HomeFeature.State, communityState: CommunityFeature.State, chatState: ChatListFeature.State, myPageState: MyPageFeature.State)
    
    // 로그인 / 회원가입 화면
    case login(onWindow: UIWindow)
    case authenticatePhoneNumber(AuthenticateFeature.State)
    case setInitialProfile(SetProfileFeature.State)
    case selectEitherCatOrDog(SelectEitherCatOrDogFeature.State)
    case addPet(AddPetFeature.State)
    
    // 돌봄급구 글쓰기
    case selectPet(state: SelectPetFeature.State)
    case selectCareCondition(state: SelectCareConditionFeature.State)
    case selectOtherRequirements(state: SelectOtherRequirementsFeature.State)
    case writeUrgentPost(state: WriteUrgentPostFeature.State)
    
    // 돌봄급구 상세
    case urgentPostDetail(state: UrgentPostDetailFeature.State)
    
    // Custom
    case custom(ViewProvidable.PresentableView)

    
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
				
				// 로그인 / 회원가입 화면
				
			case .authenticatePhoneNumber(let state):
				return AuthenticatePhoneNumberViewController(
					store: .init(initialState: state, reducer: { AuthenticateFeature() })
				)
				
			case .setInitialProfile(let state):
				return SetProfileViewController(
					store: .init(initialState: state, reducer: { SetProfileFeature() })
				)
				
			case .selectEitherCatOrDog(let state):
				return SelectEitherCatOrDogViewController(
					store: .init(initialState: state, reducer: { SelectEitherCatOrDogFeature() })
				)
        
      case .addPet(let state):
        return AddPetViewController(
          store: .init(initialState: state, reducer: { AddPetFeature() })
        )
        
        // 돌봄급구 글쓰기 Flow
				
      case .selectPet(let state):
        return SelectPetViewController(
          store: .init(initialState: state, reducer: { SelectPetFeature() })
        )
        
      case .selectCareCondition(let state):
        return SelectCareConditionsViewController(store: .init(initialState: state, reducer: SelectCareConditionFeature() ))
        
      case .selectOtherRequirements(let state):
        return SelectOtherRequirementsViewController(store: .init(initialState: state, reducer: SelectOtherRequirementsFeature() ))
        
      case .writeUrgentPost(let state):
        return UIHostingController(rootView: WriteUrgentPostView(store: .init(initialState: .init(), reducer: WriteUrgentPostFeature())))

        // 돌봄급구 상세 Flow
				
      case .urgentPostDetail(let state):
        return UIHostingController(rootView: UrgentPostDetailView(store: .init(initialState: state, reducer: UrgentPostDetailFeature())))
        
        // Custom
        
      case .custom(let vc):
        return vc
        
      default:
        assertionFailure("❌ Destination.createView() case NOT DEFINED")
        return .init()
      }
    }
  }
}

