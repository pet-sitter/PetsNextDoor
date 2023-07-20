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


protocol LoginServicable {

  @MainActor
  func signInWithGoogle() async -> LoginResult
}


final class LoginService: LoginServicable {
  
  @MainActor
  func signInWithGoogle() async -> LoginResult {
    
    guard
      let clientId  = FirebaseApp.app()?.options.clientID,
      let topMostVC = UIApplication.topViewController()
    else { return .failed(reason: .undefined) }

    let googleIdConfig = GIDConfiguration(clientID: clientId)
    GIDSignIn.sharedInstance.configuration = googleIdConfig
    
    return await withCheckedContinuation { continuation in
   
      GIDSignIn.sharedInstance.signIn(withPresenting: topMostVC) { result, error in
        
        if let error {
          return continuation.resume(returning: .failed(reason: .undefined))
        }
        
        guard
          let user    = result?.user,
          let idToken = user.idToken?.tokenString
        else {
          return continuation.resume(returning: .failed(reason: .undefined))
        }
        
        let credential = GoogleAuthProvider.credential(
          withIDToken: idToken,
          accessToken: user.accessToken.tokenString
        )
        
        return continuation.resume(returning: .success(isUserRegistrationNeeded: true))
      }
    }
  }
  

}

//MARK: - Private Methods

extension LoginService {
  
  
}



final class LoginServiceMock: LoginServicable {
  
  @MainActor
  func signInWithGoogle() async -> LoginResult {
    return .failed(reason: .undefined)
  }
  
}
