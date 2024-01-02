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


protocol LoginServiceProvidable: PNDNetworkProvidable {

  @MainActor
  func signInWithGoogle() async -> LoginResult
  func registerUser(
    model: PND.UserRegistrationModel,
    profileImageData: Data
  ) async throws
}


final class LoginService: LoginServiceProvidable {

  typealias Network = PND.Network<PND.API>
  
  private(set) var network: Network = .init()
  private let uploadService = UploadService()
  
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
      
      let credential = GoogleAuthProvider.credential(
        withIDToken: idToken,
        accessToken: signInResult.user.accessToken.tokenString
      )
      
      let authSignInResult = try? await Auth.auth().signIn(with: credential)
      let signedInUser = authSignInResult?.user
      
      
      if isUserRegistrationNeeded {     // 가입된 계정이 없다면 FireBase 계정 생성 및 Firebase 로그인 진행
    
        return .success(
          isUserRegistrationNeeded: true,
          userRegisterModel: .init(
            email: signedInUser?.email ?? "",
            fbProviderType: .google,
            fbUid: signedInUser?.uid ?? "",
            fullname: signedInUser?.displayName ?? "",
            profileImageId: 0
          )
        )

      } else {                          //가입된 계정이 있다면 그대로 로그인 진행
        print("✅ User register is not needed login proceeding")
        
        PNDTokenStore.shared.setAccessTokenValue(to: idToken)
        
        return .success(
          isUserRegistrationNeeded: false,
          userRegisterModel: nil
        )
      }

    } catch {
      return .failed(reason: .undefined)
    }
  }
  
  func registerUser(
    model: PND.UserRegistrationModel,
    profileImageData: Data
  ) async throws {
    
    var registrationModel = model
    
    let imageModel = try await uploadService.uploadImage(
      imageData: profileImageData,
      imageName: "profileImage"
    )
    
    registrationModel.profileImageId = imageModel.id
    
    try await network.plainRequest(.registerUser(model: registrationModel))
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
  
  func registerUser(
    model: PND.UserRegistrationModel,
    profileImageData: Data
  ) async throws {
    ()
  }

}
