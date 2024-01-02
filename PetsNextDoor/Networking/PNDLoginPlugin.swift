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
      "Bearer \(PNDTokenStore.shared.accessToken)",
      forHTTPHeaderField: "Authorization"
    )
    
    return newRequest
  }
}
