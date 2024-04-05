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
  case onRefreshTokenFailure
}

enum LoginResult {
  case success(isUserRegistrationNeeded: Bool, userRegisterModel: PND.UserRegistrationModel?)
  case failed(reason: AuthError)
}


protocol LoginServiceProvidable: PNDNetworkProvidable {

  @MainActor
  func signInWithGoogle() async -> LoginResult
  func registerUser(model: PND.UserRegistrationModel) async throws
  func logout()
}

protocol TokenRefreshable {
  func refreshToken() async throws
  func refreshToken(completion: @escaping (AuthError?) -> Void)
}


final class LoginService: LoginServiceProvidable, TokenRefreshable {

  typealias Network = PND.Network<PND.API>
  
  private(set) var network        = Network()
  private let uploadService       = MediaService()
  private let userDefaultsManager = UserDefaultsManager()
  private let keyChainService     = KeychainService()
  
  static let shared = LoginService()
  
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
      
      guard let idToken = signInResult.user.idToken?.tokenString else { return .failed(reason: .undefined) }
      let accessToken   = signInResult.user.accessToken.tokenString
      
      let credential = GoogleAuthProvider.credential(
        withIDToken: idToken,
        accessToken: accessToken
      )
      
      let authSignInResult = try? await Auth.auth().signIn(with: credential)
      
      let signedInUser = authSignInResult?.user
      guard let token = try await Auth.auth().currentUser?.getIDToken() else { return .failed(reason: .undefined) }
  
      PNDTokenStore.shared.setTokenInfo(to: .init(accessToken: token)) //

      if isUserRegistrationNeeded {     // 가입된 계정이 없다면 FireBase 계정 생성 및 자체 PND 서버 로그인 진행
        return .success(
          isUserRegistrationNeeded: true,
          userRegisterModel: .init(
            email: signedInUser?.email ?? "",
            fbProviderType: .google,
            fbUid: signedInUser?.uid ?? "",
            fullname: signedInUser?.displayName ?? ""
          )
        )
      } else {                          // 가입된 계정이 있다면 그대로 로그인 진행
        userDefaultsManager.set(.isLoggedIn, to: true)
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
  
  func refreshToken() async throws {
    guard let token = try await Auth.auth().currentUser?.getIDToken()
    else { throw AuthError.onRefreshTokenFailure }
    
    PNDTokenStore.shared.setTokenInfo(to: .init(accessToken: token))
  }
  
  func refreshToken(completion: @escaping (AuthError?) -> Void) {
    Task {
      guard let token = try await Auth.auth().currentUser?.getIDTokenResult(forcingRefresh: true)
      else {
        completion(AuthError.onRefreshTokenFailure)
        return
      }

      PNDTokenStore.shared.setTokenInfo(to: .init(accessToken: token.token))
      completion(nil)
    }
  }
  
  func logout() {
    keyChainService.delete(.accessToken)
    keyChainService.delete(.refreshToken)
    
    // change root view controller to LoginView
  }
}

//MARK: - Private Methods

extension LoginService {
  
  private func checkUserRegistrationStatus(withEmail email: String) async -> PND.UserRegistrationStatus? {
    return try? await network.requestData(.postUserStatus(email: email))
  }
}





final class LoginServiceMock: LoginServiceProvidable {

  typealias Network = PND.MockNetwork<PND.API>
  
  private(set) var network: Network = .init()

  func signInWithGoogle() async -> LoginResult {
    return .failed(reason: .undefined)
  }
  
  func registerUser(model: PND.UserRegistrationModel) async throws {
    ()
  }
  
  func logout() {
    ()
  }
  
}
