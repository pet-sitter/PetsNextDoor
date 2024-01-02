//
//  PNDTokenStore.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/30.
//

import Foundation

final class PNDTokenStore {
  
  static let shared = PNDTokenStore()
    
  private(set) var accessToken: String = ""
  
  private init() {}
  
  func setAccessTokenValue(to accessToken: String) {
    PNDLogger.default.info("access token set to: \(accessToken)")
    self.accessToken = accessToken
  }
}
