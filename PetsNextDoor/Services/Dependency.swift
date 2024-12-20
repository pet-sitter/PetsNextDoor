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
    static let testValue: any MediaServiceProvidable = MediaServiceMock()
  }
  
  enum SOSPostServiceKey: DependencyKey {
    static let liveValue: any SOSPostServiceProvidable = SOSPostService()
    static let testValue: any SOSPostServiceProvidable = MockSosPostService()
  }

  enum PetServiceKey: DependencyKey {
    static let liveValue: any PetServiceProvidable = PetService()
    static let testValue: any PetServiceProvidable = PetServiceMock()
  }
  
  enum MediaServiceKey: DependencyKey {
    static let liveValue: any MediaServiceProvidable = MediaService()
    static let testValue: any MediaServiceProvidable = MediaServiceMock()
  }
  
  enum KeyChainKey: DependencyKey {
    static let liveValue: any KeyChainProvidable = KeychainService()
  }
  
  enum UserDefaultsManagerKey: DependencyKey {
    static let liveValue: any UserDefaultsManageable = UserDefaultsManager()
  }
  
  enum UserDataCenterKey: DependencyKey {
    static let liveValue: UserDataCenter = UserDataCenter.shared
  }
  
  enum ChatDataProviderKey: DependencyKey {
    static let liveValue: ChatDataProvider = ChatDataProvider()
  }
  
  enum ChatAPIServiceKey: DependencyKey {
    static let liveValue: any ChatAPIServiceProvidable = ChatAPIService()
    static let testValue: any ChatAPIServiceProvidable = MockChatAPIService()
  }
  
  enum EventServiceKey: DependencyKey {
    static let liveValue: any EventServiceProvidable = EventService()
    static let testValue: any EventServiceProvidable = MockEventService()
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
    set { self[PND.Dependency.SOSPostServiceKey.self] = newValue }
  }
  
  var petService: any PetServiceProvidable {
    get { self[PND.Dependency.PetServiceKey.self] }
    set { self[PND.Dependency.PetServiceKey.self] = newValue }
  }
  
  var mediaService: any MediaServiceProvidable {
    get { self[PND.Dependency.MediaServiceKey.self] }
    set { self[PND.Dependency.MediaServiceKey.self] = newValue }
  }
  
  var keychain: any KeyChainProvidable {
    get { self[PND.Dependency.KeyChainKey.self] }
    set { self[PND.Dependency.KeyChainKey.self] = newValue }
  }
  
  var userDefaultsManager: any UserDefaultsManageable {
    get { self[PND.Dependency.UserDefaultsManagerKey.self] }
    set { self[PND.Dependency.UserDefaultsManagerKey.self] = newValue }
  }
  
  var userDataCenter: UserDataCenter {
    get { self[PND.Dependency.UserDataCenterKey.self] }
    set { self[PND.Dependency.UserDataCenterKey.self] = newValue }
  }
  
  var chatDataProvider: ChatDataProvider {
    get { self[PND.Dependency.ChatDataProviderKey.self] }
    set { self[PND.Dependency.ChatDataProviderKey.self] = newValue }
  }
  
  var chatAPIService: any ChatAPIServiceProvidable {
    get { self[PND.Dependency.ChatAPIServiceKey.self] }
    set { self[PND.Dependency.ChatAPIServiceKey.self] = newValue }
  }
  
  var eventService: any EventServiceProvidable {
    get { self[PND.Dependency.EventServiceKey.self] }
    set { self[PND.Dependency.EventServiceKey.self] = newValue }
  }
}


