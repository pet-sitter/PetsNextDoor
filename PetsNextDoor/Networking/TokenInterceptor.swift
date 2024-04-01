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
      let accessToken = UserDefaultsManager.shared.get(.accessToken) as? String,
      let refreshToken = UserDefaultsManager.shared.get(.refreshToken) as? String
    else {
      PNDTokenStore.shared.removeAllTokenInfo()
      completion(.doNotRetryWithError(error))
      return
    }
    
    // Refresh Token 재발급 로직 삽입
    

//         guard let accessToken = keychain.read(.accessToken),
//               let refreshToken = keychain.read(.refreshToken) else {
//             deleteAllToken()
//             completion(.doNotRetryWithError(error))
//             return
//         }
//         let tokenRequest = TokenRequest(accessToken: accessToken, refreshToken: refreshToken)
//
//         Task {
//             do {
//                 let tokenResponse = try await authClient.reissueToken(tokenRequest)
//
//                 guard let accessToken = tokenResponse.accessToken,
//                       let refreshToken = tokenResponse.refreshToken else {
//                     deleteAllToken()
//                     completion(.doNotRetryWithError(error))
//                     return
//                 }
//
//                 keychain.save(.accessToken, accessToken)
//                 keychain.save(.refreshToken, refreshToken)
//
//                 completion(.retryWithDelay(1))
//             } catch {
//                 deleteAllToken()
//                 completion(.doNotRetryWithError(error))
//             }
//         }
//     }
  
  
  }
  

}
