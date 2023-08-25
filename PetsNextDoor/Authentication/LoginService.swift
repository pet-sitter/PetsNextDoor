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
  case userEmailUnavailable
}

enum LoginResult {
  case success(isUserRegistrationNeeded: Bool)
  case failed(reason: AuthError)
}



protocol LoginServiceable: PNDNetworkProvidable {
  @MainActor
  func signInWithGoogle() async -> LoginResult
}


final class LoginService: LoginServiceable {

  typealias Network = PND.Network<PND.API>
  
  private(set) var network: Network = .init()
  
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
      
      guard let email = signInResult.user.profile?.email else { return .failed(reason: .userEmailUnavailable) }
    
      print("✅ email: \(email)")
      
      guard let userRegistrationStatus = await checkUserRegistrationStatus(withEmail: email)
      else { return .failed(reason: .undefined) }
      
      return .success(isUserRegistrationNeeded: userRegistrationStatus.status == .notRegistered ? true : false)

    } catch {
      return .failed(reason: .undefined)
    }
    
    
  }
  
 
  
}

//MARK: - Private Methods

extension LoginService {
  
  private func checkUserRegistrationStatus(withEmail email: String) async -> PND.UserRegistrationStatus? {
    try? await network.requestData(.postUserStatus(email: email))
  }
  
}



final class LoginServiceMock: LoginServiceable {
  
  typealias Network = PND.MockNetwork<PND.API>
  
  private(set) var network: Network = .init()

  @MainActor
  func signInWithGoogle() async -> LoginResult {
    return .failed(reason: .undefined)
  }

}
