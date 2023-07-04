//
//  ActionPrinter.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/03.
//

import Foundation

extension MiddleWares {
  
  static let printer: Middleware<AppState> = { state, action in
    
    switch action {
    
    default: break
    }
    
    #if DEBUG
    print("✅  #[PRINT] ACTION + \(action)")
     print("✏️ #[PRINT] STATE + \(state)")
    #endif
    return nil
  }
}
