//
//  PNDLoginPlugin.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/30.
//

import Foundation
import Moya

final class PNDLoginPlugin: PluginType {
  
  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
     
    var newRequest = request
    newRequest.setValue(
      "\(PNDTokenStore.shared.accessToken)",
      forHTTPHeaderField: "Authorization"
    )
    print("✅ accessToken: \(PNDTokenStore.shared.accessToken)")
    return newRequest
  }
  
  
}
