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
    keyChainService.read(.accessToken) ?? "Invalid Access Token"
  }
  
  private init() {}
  
  func setTokenInfo(to tokenInfo: TokenInfo) {
    PNDLogger.default.info("access token set to: \(tokenInfo.accessToken)")
    
    keyChainService.save(.accessToken, tokenInfo.accessToken)
  }
  
  func removeAllTokenInfo() {
    keyChainService.delete(.accessToken)
  }
}

extension PNDTokenStore {
  
  struct TokenInfo {
    let accessToken: String
  }
}
