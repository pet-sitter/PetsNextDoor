//
//  DependencyKeys.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/09.
//

import Foundation
import ComposableArchitecture

extension PND {
  enum Dependency {}
}

extension PND.Dependency {
  
  enum LoginServiceKey: DependencyKey {
    static let liveValue: any LoginServicable = LoginService()
    static let testValue: any LoginServicable = LoginServiceMock()
  }
}

extension DependencyValues {
  var loginService: any LoginServicable {
    get { self[PND.Dependency.LoginServiceKey.self] }
    set { self[PND.Dependency.LoginServiceKey.self] = newValue }
  }
}

