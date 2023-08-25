//
//  Network.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/25.
//

import Foundation
import Moya

extension PND {
  
  final class Network<Target: Moya.TargetType>: NetworkProvidable {
    
    typealias APITarget = PND.API
    
    var provider: Moya.MoyaProvider<PND.API>
    
    init() {
      let session = MoyaProvider<APITarget>.defaultAlamofireSession()
      session.sessionConfiguration.timeoutIntervalForRequest  = 20
      session.sessionConfiguration.timeoutIntervalForResource = 20
      self.provider = MoyaProvider<APITarget>(
        session: session
      )
    }
  }
}

extension PND {
  
  final class MockNetwork<Target: Moya.TargetType>: NetworkProvidable {
    
    typealias APITarget = PND.API
    
    var provider: MoyaProvider<PND.API>
    
    init() {
      self.provider = MoyaProvider<APITarget>()
    }
  }
}

