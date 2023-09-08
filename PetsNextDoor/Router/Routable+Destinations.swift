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
    case main
    case login(onWindow: UIWindow)
    case authenticatePhoneNumber(AuthenticateFeature.State)
    case setInitialProfile(SetProfileFeature.State)
    
    func createView() -> PresentableView {
      switch self {
        
      case .main:
        return MainTabBarController()
        
        
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

