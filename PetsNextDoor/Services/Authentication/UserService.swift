//
//  UserService.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/30.
//

import Foundation

protocol UserServiceProvidable: PNDNetworkProvidable {
  
  func checkNicknameDuplication(_ nickname: String) async throws -> PND.CheckNicknameModel
  func getMyPets() async throws -> PND.MyPetListModel
  func registerMyPets(_ pets: [PND.Pet]) async throws
}

final class UserService: UserServiceProvidable {

  typealias Network = PND.Network<PND.API>
  
  private(set) var network: Network = .init()
  private let uploadService = MediaService()
  
  func checkNicknameDuplication(_ nickname: String) async throws -> PND.CheckNicknameModel {
    try await network.requestData(.postCheckNickname(nickname: nickname))
  }
  
  func getMyPets() async throws -> PND.MyPetListModel {
    try await network.requestData(.getMyPets)
  }
  
  func registerMyPets(_ pets: [PND.Pet]) async throws {
    try await network.plainRequest(.putMyPets(model: pets))
  }
}



final class UserServiceMock: UserServiceProvidable {
  
  typealias Network = PND.MockNetwork<PND.API>
  
  private(set) var network: Network = .init()
  
  func checkNicknameDuplication(_ nickname: String) async throws -> PND.CheckNicknameModel {
    try await network.requestData(.postCheckNickname(nickname: nickname))
  }
  
  func getMyPets() async throws -> PND.MyPetListModel {
    try await network.requestData(.getMyPets)
  }
  
  func registerMyPets(_ pets: [PND.Pet]) async throws {
    try await network.plainRequest(.putMyPets(model: pets))
  }
}
