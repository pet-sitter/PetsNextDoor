//
//  LoginMiddleWare.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/09.
//

import Foundation

struct LoginMiddleWare: MiddleWare {
  
  private let loginService: LoginServicable
  
  init(loginService: LoginServicable) {
    self.loginService = loginService
  }

  func beginGoogleLogin() async throws {
    try await loginService.signInWithGoogle()
  }
}

