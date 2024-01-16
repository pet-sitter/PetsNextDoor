//
//  PetService.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/16.
//

import Foundation

protocol PetServiceProvidable: PNDNetworkProvidable {
  
  func getBreeds(pageSize: Int, petType: PND.PetType) async throws -> PND.BreedListResponseModel
}

struct PetService: PetServiceProvidable {
  
  typealias Network = PND.Network<PND.API>
  
  private(set) var network: PND.Network<PND.API> = .init()
  
  func getBreeds(pageSize: Int, petType: PND.PetType) async throws -> PND.BreedListResponseModel {
    try await network.requestData(.getBreeds(pageSize: pageSize, petType: petType.rawValue))
  }
}

struct PetServiceMock: PetServiceProvidable {
  
  typealias Network = PND.Network<PND.API>
  
  private(set) var network: PND.Network<PND.API> = .init()
  
  func getBreeds(pageSize: Int, petType: PND.PetType) async throws -> PND.BreedListResponseModel {
    try await network.requestData(.getBreeds(pageSize: pageSize, petType: petType.rawValue))
  }
}
