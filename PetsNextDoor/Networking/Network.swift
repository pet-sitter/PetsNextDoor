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

      let configuration = URLSessionConfiguration.default
      configuration.headers = .default

      self.provider = MoyaProvider<APITarget>(
        session: Session(configuration: configuration, interceptor: TokenInterceptor()),
        plugins: [
          PNDLoginPlugin()
        ]
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

