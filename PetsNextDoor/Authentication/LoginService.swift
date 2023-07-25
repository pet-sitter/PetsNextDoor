//
//  LoginService.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/06/25.
//

import Foundation
import GoogleSignIn
import FirebaseCore
import FirebaseAuth
import AuthenticationServices

enum AuthError: Error {
  case undefined
}

enum LoginResult {
  case success(isUserRegistrationNeeded: Bool)
  case failed(reason: AuthError)
}


protocol LoginServiceable {

  @MainActor
  func signInWithGoogle() async -> LoginResult
}


final class LoginService: LoginServiceable {
  
	@MainActor
	func signInWithGoogle() async -> LoginResult {
		
		guard
			let clientId  = FirebaseApp.app()?.options.clientID,
			let topMostVC = UIApplication.topViewController()
		else { return .failed(reason: .undefined) }
		
		let googleIdConfig = GIDConfiguration(clientID: clientId)
		GIDSignIn.sharedInstance.configuration = googleIdConfig
		
		do {
			
			let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topMostVC)
			
//			signInResult.user
			
			// 가입된 계정이 있는지 자체 서버에서 verifyAPI 호출
			
				// 없으면 isUserRegistrationNeeded: true 반환
			
			// signInWithCredential을 한 결과 (유저정보)를 자체 서버에 전달
			
		  //
				
			return .success(isUserRegistrationNeeded: true)
			
			
		} catch {
			return .failed(reason: .undefined)
		}
		

	}
	
}

//MARK: - Private Methods

extension LoginService {
  
  
}



final class LoginServiceMock: LoginServiceable {
  
  @MainActor
  func signInWithGoogle() async -> LoginResult {
    return .failed(reason: .undefined)
  }
  
}
