//
//  PNDTokenStore.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/30.
//

import Foundation

final class PNDTokenStore {
  
  static let shared = PNDTokenStore()
  
  private let keyChainService = KeychainService()
    
  var accessToken: String {
    return (UserDefaultsManager.shared.get(.accessToken) as? String) ?? "Invalid Access Token"
  }
  
  private init() {}
  
  func setTokenInfo(to tokenInfo: TokenInfo) {
    PNDLogger.default.info("access token set to: \(tokenInfo.accessToken)")
    
    keyChainService.save(.accessToken, tokenInfo.accessToken)
    keyChainService.save(.refreshToken, tokenInfo.refreshToken)
  }
  
  func removeAllTokenInfo() {
    keyChainService.delete(.accessToken)
    keyChainService.delete(.refreshToken)
  }
}

extension PNDTokenStore {
  
  struct TokenInfo {
    let accessToken: String
    let refreshToken: String
  }
}
