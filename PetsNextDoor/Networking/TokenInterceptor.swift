//
//  TokenInterceptor.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/04/01.
//

import Foundation
import Alamofire

final class TokenInterceptor: RequestInterceptor {
  
  
  // AccessToken 재발급
  func retry(
    _ request: Request,
    for session: Session,
    dueTo error: Error,
    completion: @escaping (RetryResult) -> Void
  ) {
    
    guard
      let response = request.task?.response as? HTTPURLResponse,
      response.statusCode == 401
    else {
      completion(.doNotRetryWithError(error))
      return
    }
    
    guard
      let accessToken  = KeychainService().read(.accessToken),
      let refreshToken = KeychainService().read(.refreshToken)
    else {
      PNDTokenStore.shared.removeAllTokenInfo()
      completion(.doNotRetryWithError(error))
      return
    }
  }
}
