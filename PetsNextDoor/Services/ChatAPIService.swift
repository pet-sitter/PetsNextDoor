//
//  ChatAPIService.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 9/16/24.
//

import Foundation
import Moya

protocol ChatAPIServiceProvidable: PNDNetworkProvidable {
  func getChatRooms() async throws -> PND.ChatListModel
  func postChatRoom(roomName: String, roomType: String) async throws -> PND.ChatCreationModel
  func getChatRoom(roomId: String) async throws -> PND.ChatRoomModel
  func joinChatRoom(roomId: String) async throws -> Response
  func leaveChatRoom(roomId: String) async throws -> Response
  func getChatRoomMessages(
    roomId: String,
    prev: Int?,
    next: Int?,
    size: Int
  ) async throws -> PND.ChatMessagesModel
}

struct ChatAPIService: ChatAPIServiceProvidable {
  
  private(set) var network: PND.Network<PND.API> = .init()
  
  typealias Network = PND.Network<PND.API>
  
  // 사용자의 채팅방 목록 조회
  func getChatRooms() async throws -> PND.ChatListModel {
    try await network.requestData(.getChatRooms)
  }
  
  // 채팅방 생성
  func postChatRoom(roomName: String, roomType: String) async throws -> PND.ChatCreationModel {
    try await network.requestData(.postChatRoom(roomName: roomName, roomType: roomType))
  }
  
  // 채팅방 조회
  func getChatRoom(roomId: String) async throws -> PND.ChatRoomModel {
    try await network.requestData(.getChatRoom(roomId: roomId))
  }
  
  // 채팅방 참가
  func joinChatRoom(roomId: String) async throws -> Response {
    try await network.plainRequest(.postJoinChatRoom(roomId: roomId))
  }
  
  // 채팅방 나가기
  func leaveChatRoom(roomId: String) async throws -> Response {
    try await network.plainRequest(.postLeaveChatRoom(roomId: roomId))
  }
  
  // 채팅방 메시지 조회
  func getChatRoomMessages(
    roomId: String,
    prev: Int? = nil,
    next: Int? = nil,
    size: Int = 30
  ) async throws -> PND.ChatMessagesModel {
    try await network.requestData(.getChatRoomMessages(
      roomId: roomId,
      prev: prev,
      next: next,
      size: size
    ))
  }
}

struct MockChatAPIService: ChatAPIServiceProvidable {
  
  typealias Network = PND.MockNetwork<PND.API>
  
  private(set) var network: Network = .init()
  
  func getChatRooms() async throws -> PND.ChatListModel {
    return PND.ChatListModel(items: [
      PND.ChatRoomModel(
        createdAt: "1726472095",
        id: "123",
        joinUsers: [
          PND.JoinUser(
            profileImageUrl: "",
            userId: "12313",
            userNickname: "nickname test"
          )
        ],
        roomName: "방 이름 테스트",
        roomType: "EVENT",
        updatedAt: "1726472095"
      )
    ])
  }
  
  func postChatRoom(roomName: String, roomType: String) async throws -> PND.ChatCreationModel {
    return PND.ChatCreationModel(
      joinUserIds: ["0","1", "2"],
      roomName: "놀이 이벤트 방 이름 테스트",
      roomType: "EVENT"
    )
  }
  
  func getChatRoom(roomId: String) async throws -> PND.ChatRoomModel {
    return PND.ChatRoomModel(
      createdAt: "1726472095",
      id: UUID().uuidString,
      joinUsers: [
        .init(
          profileImageUrl: "",
          userId: UUID().uuidString,
          userNickname: "userName Test"
        )
      ],
      roomName: "놀이 이벤트 방 이름 테스트",
      roomType: "EVENT",
      updatedAt: "1726472095"
    )
  }
  
  func joinChatRoom(roomId: String) async throws -> Moya.Response {
    .init(statusCode: 200, data: .init())
  }
  
  func leaveChatRoom(roomId: String) async throws -> Moya.Response {
    .init(statusCode: 200, data: .init())
  }
  
  func getChatRoomMessages(
    roomId: String,
    prev: Int?,
    next: Int?,
    size: Int
  ) async throws -> PND.ChatMessagesModel {
    return PND.ChatMessagesModel(
      hasNext: true,
      hasPreve: true,
      items: [
        PND.ChatMessages(
          content: "안녕 메시지 테스트야",
          createdAt: "1726472095",
          id: "12",
          messageType: PND.MessageType.plain.rawValue,
          roomID: "1",
          userID: "12"
        )
      ]
    )
  }
  
}
