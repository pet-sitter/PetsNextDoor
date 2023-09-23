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
    static let liveValue: any LoginServiceProvidable = LoginService()
    static let testValue: any LoginServiceProvidable = LoginServiceMock()
  }
  
  enum UploadServiceKey: DependencyKey {
    static let liveValue: any UploadServiceProvidable = UploadService()
    static let testValue: any UploadServiceProvidable = UploadServiceMock()
  }
}

extension DependencyValues {
  
  var loginService: any LoginServiceProvidable {
    get { self[PND.Dependency.LoginServiceKey.self] }
    set { self[PND.Dependency.LoginServiceKey.self] = newValue }
  }
  
  var uploadService: any UploadServiceProvidable {
    get { self[PND.Dependency.UploadServiceKey.self] }
    set { self[PND.Dependency.UploadServiceKey.self] = newValue }
  }
}

