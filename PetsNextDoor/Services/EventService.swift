//
//  EventService.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 12/2/24.
//

import Foundation
import Moya

protocol EventServiceProvidable: PNDNetworkProvidable {
  
  func getEvents(authorId: String?, page: Int, size: Int) async throws -> PND.EventListResponseModel
  func putEvent(model: PND.Event) async throws -> Response
  func postEvent(model: PND.Event) async throws -> Response
  func getEvent(id: String) async throws -> PND.Event
  func deleteEvent(id: String) async throws -> Response
}

struct EventService: EventServiceProvidable {
  
  private(set) var network: PND.Network<PND.API> = .init()
  
  typealias Network = PND.Network<PND.API>

  func getEvents(authorId: String?, page: Int, size: Int) async throws -> PND.EventListResponseModel {
    try await network.requestData(.getEvents(authorId: authorId, page: page, size: size))
  }
  
  func putEvent(model: PND.Event) async throws -> Moya.Response {
    try await network.plainRequest(.putEvent(model: model))
  }
  
  func postEvent(model: PND.Event) async throws -> Moya.Response {
    try await network.plainRequest(.postEvent(model: model))
  }
  
  func getEvent(id: String) async throws -> PND.Event {
    try await network.requestData(.getEventDetail(id: id))
  }
  
  func deleteEvent(id: String) async throws -> Moya.Response {
    try await network.plainRequest(.deleteEvent(id: id))
  }
  
}
