//
//  SOSPostService.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/19.
//

import Foundation

protocol SOSPostServiceProvidable: PNDNetworkProvidable {
  func getSOSPosts(authorId: Int?, page: Int, size: Int, sortBy: String) async throws -> PND.SOSPostListModel
}


struct SOSPostService: SOSPostServiceProvidable {
  
  private(set) var network: PND.Network<PND.API> = .init()
  
  typealias Network = PND.Network<PND.API>
  
  func getSOSPosts(
    authorId: Int?,
    page: Int,
    size: Int,
    sortBy: String
  ) async throws -> PND.SOSPostListModel {
    try await network.requestData(.getSOSPosts(authorId: authorId, page: page, size: size, sortBy: sortBy))
  }
}






struct MockSosPostService: SOSPostServiceProvidable {
  
  typealias Network = PND.MockNetwork<PND.API>
  
  private(set) var network: Network = .init()
  
  func getSOSPosts(
    authorId: Int?,
    page: Int,
    size: Int,
    sortBy: String
  ) async throws -> PND.SOSPostListModel {
    try await network.requestData(.getSOSPosts(authorId: authorId, page: page, size: size, sortBy: sortBy))
  }
  
}
