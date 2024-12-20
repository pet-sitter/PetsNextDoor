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

struct MockEventService: EventServiceProvidable {
  
  private(set) var network = PND.MockNetwork<PND.API>()
  
  
  func getEvents(
    authorId: String?,
    page: Int,
    size: Int
  ) async throws -> PND.EventListResponseModel {
    return PND.EventListResponseModel(
      items: [
        PND.Event(
          author: PND.Author(
            id: "auth_001",
            nickname: "JohnTheWalker",
            profileImageUrl:  MockDataProvider.randomPetImageUrlString
          ),
          createdAt: "2024-12-01T10:00:00Z",
          description: "Join us for a weekly dog walking event at Central Park!",
          fee: nil,
          genderCondition: "Any",
          id: "event_001",
          maxParticipants: 12,
          media: PND.Media(
            id: "media_001",
            url: MockDataProvider.randomPetImageUrlString,
            createdAt: "2024-11-30T08:00:00Z",
            mediaType: "image"
          ),
          name: "Weekly Dog Walk",
          recurringPeriod: .weekly,
          startAt: "2024-12-23T15:00:00Z",
          topics: ["Dogs", "Community"],
          type: .recurring,
          updatedAt: "2024-12-10T12:00:00Z"
        ),
        PND.Event(
          author: PND.Author(
            id: "auth_002",
            nickname: "JaneTheHelper",
            profileImageUrl: MockDataProvider.randomPetImageUrlString
          ),
          createdAt: "2024-11-28T09:00:00Z",
          description: "Volunteer at our local animal shelter and help care for pets in need.",
          fee: 0,
          genderCondition: "Any",
          id: "event_002",
          maxParticipants: 25,
          media: PND.Media(
            id: "media_002",
            url:  MockDataProvider.randomPetImageUrlString,
            createdAt: "2024-11-27T15:00:00Z",
            mediaType: "image"
          ),
          name: "Animal Shelter Volunteering",
          recurringPeriod: .monthly,
          startAt: "2024-12-20T10:00:00Z",
          topics: ["Volunteering", "Animal Care"],
          type: .recurring,
          updatedAt: "2024-12-05T09:00:00Z"
        ),
        PND.Event(
          author: PND.Author(
            id: "auth_003",
            nickname: "ChrisPetLover",
            profileImageUrl: MockDataProvider.randomPetImageUrlString
          ),
          createdAt: "2024-12-15T13:00:00Z",
          description: "A one-time gathering at a pet-friendly café. Bring your furry friends!",
          fee: 15000,
          genderCondition: "Any",
          id: "event_003",
          maxParticipants: 10,
          media: PND.Media(
            id: "media_003",
            url:  MockDataProvider.randomPetImageUrlString,
            createdAt: "2024-12-14T10:00:00Z",
            mediaType: "image"
          ),
          name: "Pet Café Meetup",
          recurringPeriod: nil,
          startAt: "2024-12-24T18:00:00Z",
          topics: ["Pets", "Socializing"],
          type: .shortTerm,
          updatedAt: nil
        )
      ],
      next: nil,
      prev: nil
    )
  }
  
  func putEvent(model: PND.Event) async throws -> Moya.Response {
    return .init(statusCode: Int.randomStatusCode(), data: Data())
  }
  
  func postEvent(model: PND.Event) async throws -> Moya.Response {
    return .init(statusCode: Int.randomStatusCode(), data: Data())
  }
  
  func getEvent(id: String) async throws -> PND.Event {
    return PND.Event(
      author: PND.Author(
        id: "auth_003",
        nickname: "ChrisPetLover",
        profileImageUrl: MockDataProvider.randomPetImageUrlString
      ),
      createdAt: "2024-12-15T13:00:00Z",
      description: "A one-time gathering at a pet-friendly café. Bring your furry friends!",
      fee: 15000,
      genderCondition: "Any",
      id: "event_003",
      maxParticipants: 10,
      media: PND.Media(
        id: "media_003",
        url:  MockDataProvider.randomPetImageUrlString,
        createdAt: "2024-12-14T10:00:00Z",
        mediaType: "image"
      ),
      name: "Pet Café Meetup",
      recurringPeriod: nil,
      startAt: "2024-12-24T18:00:00Z",
      topics: ["Pets", "Socializing"],
      type: .shortTerm,
      updatedAt: nil
    )
  }
  
  func deleteEvent(id: String) async throws -> Moya.Response {
    return .init(statusCode: Int.randomStatusCode(), data: Data())
  }
  
  

}
