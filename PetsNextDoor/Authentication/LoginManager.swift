//
//  LoginManager.swift
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

enum SocialLoginType {
  case apple
  case google
  case kakao
}

protocol LoginServicable {

  @MainActor
  func signInWithGoogle() async throws -> AuthCredential
  
//  @MainActor
//  func signInWithApple() async throws -> ASAuthorizationAppleIDCredential
}

final class LoginManager: LoginServicable {
  
  @MainActor
  func signInWithGoogle() async throws -> AuthCredential {
    
    guard
      let clientId  = FirebaseApp.app()?.options.clientID,
      let topMostVC = UIApplication.topViewController()
    else { throw AuthError.undefined }

    let googleIdConfig = GIDConfiguration(clientID: clientId)
    GIDSignIn.sharedInstance.configuration = googleIdConfig
    
    return try await withCheckedThrowingContinuation { continuation in
   
      GIDSignIn.sharedInstance.signIn(withPresenting: topMostVC) { result, error in
        
        if let error {
          return continuation.resume(throwing: error)
        }
        
        guard
          let user    = result?.user,
          let idToken = user.idToken?.tokenString
        else {
          return continuation.resume(throwing: AuthError.undefined)
        }
        
        let credential = GoogleAuthProvider.credential(
          withIDToken: idToken,
          accessToken: user.accessToken.tokenString
        )
        
        return continuation.resume(returning: credential)
      }
    }
  }
  
//  @MainActor
//  func signInWithApple() async throws -> ASAuthorizationAppleIDCredential {
//
//    // Apple Developer 지원해야함
//
//  }
}
