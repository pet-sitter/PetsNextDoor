//
//  UserService.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/30.
//

import Foundation


protocol UserServiceProvidable: PNDNetworkProvidable {
  
  func registerMyPets(_ pets: [PND.Pet]) async throws
}

final class UserService: UserServiceProvidable {

  typealias Network = PND.Network<PND.API>
  
  private(set) var network: Network = .init()
  private let uploadService = UploadService()
  
  func registerMyPets(_ pets: [PND.Pet]) async throws {
    try await network.plainRequest(.putMyPets(model: pets))
  }
  
  
}

final class UserServiceMock: UserServiceProvidable {
  
  typealias Network = PND.MockNetwork<PND.API>
  
  private(set) var network: Network = .init()
  
  func registerMyPets(_ pets: [PND.Pet]) async throws {
    ()
  }
}
