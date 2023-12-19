//
//  DependencyKeys.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/19.
//

import Foundation
import ComposableArchitecture



extension DependencyValues {
  
  var sosPostService: any SOSPostServiceProvidable {
    get { self[SOSPostServiceKey.self] }
    set { self[SOSPostServiceKey.self] = newValue}
  }
}


private enum SOSPostServiceKey: DependencyKey {
  
  static let liveValue: any SOSPostServiceProvidable = SOSPostService()
  static let testValue: any SOSPostServiceProvidable = MockSosPostService()
  
  
  
}
