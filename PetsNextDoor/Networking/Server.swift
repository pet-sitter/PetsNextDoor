//
//  Server.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import Foundation

struct Server {
  
  enum ServerPhase: Int {
    case dev = 0
    case prod
  }
  
  struct EndPoint {
    
    
  }
  
  private(set) var currentServerPhase: ServerPhase
  
  
  mutating func changeServerPhase(to phase: ServerPhase) {
    self.currentServerPhase = phase
  }
  
}


extension Server {
  
  var isDev: Bool   { currentServerPhase == .dev }
  var isProd: Bool  { currentServerPhase == .prod}
}
