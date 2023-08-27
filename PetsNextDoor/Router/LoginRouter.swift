//
//  LoginRouter.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/07/25.
//

import Foundation
import ComposableArchitecture

final class LoginRouter: Routable {
	
	@MainActor
	func route(to destination: PND.Destination) {
		
		switch destination {
		case .authenticatePhoneNumber(let state):
			
      let vc = AuthenticatePhoneNumberViewController(
        store: .init(
          initialState: state,
          reducer: { AuthenticateFeature() }),
        router: LoginRouter()
      )
			
			AppRouter
				.shared
				.rootViewController
				.mainNavigationController?
				.pushViewController(vc, animated: true)
			
		case .setInitialProfile(let state):
			
			let vc = SetProfileViewController(
				store: .init(
					initialState: state,
					reducer: { SetProfileFeature() }
				),
				router: LoginRouter()
			)
			
			AppRouter
				.shared
				.rootViewController
				.mainNavigationController?
				.pushViewController(vc, animated: true)
			
		default: break
		}
	}
	
	
	
}
