//
//  SOSPostService.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/19.
//

import Foundation

protocol SOSPostServiceProvidable: PNDNetworkProvidable {
  func getSOSPosts(authorId: Int?, page: Int, size: Int, sortBy: String, filterType: PND.FilterType ) async throws -> PND.SOSPostListModel
  func getSOSPostDetail(id: Int) async throws -> PND.SOSPostDetailModel
  func postSOSPost(model: PND.UrgentPostModel) async throws -> PND.SOSPostDetailModel
  func getSOSConditions() async throws -> [PND.Condition]
}


struct SOSPostService: SOSPostServiceProvidable {
  
  private(set) var network: PND.Network<PND.API> = .init()
  
  typealias Network = PND.Network<PND.API>
  
  func getSOSPosts(
    authorId: Int?,
    page: Int,
    size: Int,
    sortBy: String,
    filterType: PND.FilterType
  ) async throws -> PND.SOSPostListModel {
    try await network.requestData(
      .getSOSPosts(
        authorId: authorId,
        page: page,
        size: size,
        sortBy: sortBy,
        filterType: filterType.rawValue
      )
    )
  }
  
  func getSOSPostDetail(id: Int) async throws -> PND.SOSPostDetailModel {
    try await network.requestData(.getSOSPostDetail(id: id))
  }
  
  func postSOSPost(model: PND.UrgentPostModel) async throws -> PND.SOSPostDetailModel {
    try await network.requestData(.postSOSPost(model: model))
  }
  
  func getSOSConditions() async throws -> [PND.Condition] {
    try await network.requestData(.getSOSConditons)
  }
}





//TODO: - Mock data 추가하기

struct MockSosPostService: SOSPostServiceProvidable {
  
  typealias Network = PND.MockNetwork<PND.API>
  
  private(set) var network: Network = .init()
  
  func getSOSPosts(
    authorId: Int?,
    page: Int,
    size: Int,
    sortBy: String,
    filterType: PND.FilterType
  ) async throws -> PND.SOSPostListModel {
    try await network.requestData(
      .getSOSPosts(
        authorId: authorId,
        page: page,
        size: size,
        sortBy: sortBy,
        filterType: filterType.rawValue
      )
    )
  }
  
  func getSOSPostDetail(id: Int) async throws -> PND.SOSPostDetailModel {
    try await network.requestData(.getSOSPostDetail(id: id))
  }
  
  func postSOSPost(model: PND.UrgentPostModel) async throws -> PND.SOSPostDetailModel {
    try await network.requestData(.postSOSPost(model: model))
  }
  
  func getSOSConditions() async throws -> [PND.Condition] {
    return [
      PND.Condition(id: "1", name: "CCTV, 펫캠 촬영 동의"),
      PND.Condition(id: "2", name: "신분증 인증"),
      PND.Condition(id: "3", name: "사전 통화 가능 여부"),
    ]
  }
}
