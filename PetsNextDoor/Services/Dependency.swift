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
  
  enum UserServiceKey: DependencyKey {
    static let liveValue: any UserServiceProvidable = UserService()
    static let testValue: any UserServiceProvidable = UserServiceMock()
  }
  
  enum UploadServiceKey: DependencyKey {
    static let liveValue: any MediaServiceProvidable = MediaService()
    static let testValue: any MediaServiceProvidable = UploadServiceMock()
  }
  
  enum SOSPostServiceKey: DependencyKey {
    static let liveValue: any SOSPostServiceProvidable = SOSPostService()
    static let testValue: any SOSPostServiceProvidable = MockSosPostService()
  }

}

extension DependencyValues {
  
  var loginService: any LoginServiceProvidable {
    get { self[PND.Dependency.LoginServiceKey.self] }
    set { self[PND.Dependency.LoginServiceKey.self] = newValue }
  }
  
  var userService: any UserServiceProvidable {
    get { self[PND.Dependency.UserServiceKey.self] }
    set { self[PND.Dependency.UserServiceKey.self] = newValue }
  }
  
  var uploadService: any MediaServiceProvidable {
    get { self[PND.Dependency.UploadServiceKey.self] }
    set { self[PND.Dependency.UploadServiceKey.self] = newValue }
  }
  
  var sosPostService: any SOSPostServiceProvidable {
    get { self[PND.Dependency.SOSPostServiceKey.self] }
    set { self[PND.Dependency.SOSPostServiceKey.self] = newValue}
  }
}

