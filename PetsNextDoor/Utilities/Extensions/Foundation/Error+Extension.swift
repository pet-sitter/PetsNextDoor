//
//  Error+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/04/02.
//

import Foundation
import Moya

extension Error {
  
  var isUnauthorizedError: Bool {
    let statusCode = self.asMoyaError?.response?.statusCode ?? -1
    return statusCode == 401 ? true : false
  }
  
  var asMoyaError: MoyaError? {
    self as? MoyaError
  }
}
