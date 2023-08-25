//
//  Server.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import Foundation

extension PND {
  
  struct Server {
    
    //TODO: - 아래 변경 (동적으로 변경 가능하도록)
    static let shared = Server(currentServerPhase: .dev)
    
    enum ServerPhase: Int {
      case dev = 0
      case prod
    }
    
    private(set) var currentServerPhase: ServerPhase
    
    mutating func changeServerPhase(to phase: ServerPhase) {
      self.currentServerPhase = phase
    }
  }
}

extension PND.Server {
  var isDev: Bool   { currentServerPhase == .dev  }
  var isProd: Bool  { currentServerPhase == .prod }
}
