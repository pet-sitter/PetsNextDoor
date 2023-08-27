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
  case failedCheckingUserRegistrationStatus
}

enum LoginResult {
  case success(isUserRegistrationNeeded: Bool, userRegisterModel: PND.UserRegistrationModel?)
  case failed(reason: AuthError)
}


protocol LoginServiceable: PNDNetworkProvidable {

  @MainActor
  func signInWithGoogle() async -> LoginResult
  func registerUser(model: PND.UserRegistrationModel) async throws
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
      let signInResult  = try await GIDSignIn.sharedInstance.signIn(withPresenting: topMostVC)
      
      guard let email = signInResult.user.profile?.email else { return .failed(reason: .userEmailUnavailable) }
  
      guard let userRegistrationStatus = await checkUserRegistrationStatus(withEmail: email)
      else { return .failed(reason: .failedCheckingUserRegistrationStatus) }
      
      let isUserRegistrationNeeded: Bool = userRegistrationStatus.status == .notRegistered ? true : false

      if isUserRegistrationNeeded {     // 가입된 계정이 없다면 FireBase 계정 생성 및 Firebase 로그인 진행
        
        guard let idToken = signInResult.user.idToken?.tokenString else { return .failed(reason: .undefined) }
        
        let credential = GoogleAuthProvider.credential(
          withIDToken: idToken,
          accessToken: signInResult.user.accessToken.tokenString
        )
        
        let authSignInResult = try? await Auth.auth().signIn(with: credential)
        let signedInUser = authSignInResult?.user
      
        return .success(
          isUserRegistrationNeeded: true,
          userRegisterModel: .init(
            email: signedInUser?.email ?? "",
            fbProviderType: .google,
            fbUid: signedInUser?.uid ?? "",
            fullname: signedInUser?.displayName ?? ""
          )
        )

      } else {                          //가입된 계정이 있다면 그대로 로그인 진행
        return .success(
          isUserRegistrationNeeded: false,
          userRegisterModel: nil
        )
      }

    } catch {
      return .failed(reason: .undefined)
    }
  }
  
  func registerUser(model: PND.UserRegistrationModel) async throws {
    try await network.plainRequest(.registerUser(model: model))
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

  func signInWithGoogle() async -> LoginResult {
    return .failed(reason: .undefined)
  }
  
  func registerUser(model: PND.UserRegistrationModel) async throws {
    ()
  }

}
