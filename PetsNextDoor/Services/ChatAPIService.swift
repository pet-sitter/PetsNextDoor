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
    prev: String?,
    next: String?,
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
    prev: String? = nil,
    next: String? = nil,
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
    prev: String?,
    next: String?,
    size: Int
  ) async throws -> PND.ChatMessagesModel {
    defer {
      MockChatAPIService.getChatRoomMessagesCalledCount += 1
    }
    if MockChatAPIService.getChatRoomMessagesCalledCount == 0 {
      return PND.ChatMessagesModel(
        hasNext: true,
        hasPrev: true,
        next: nil,
        prev: nil,
        items: Array(chatRoomMessages[0..<10])
      )
    } else if MockChatAPIService.getChatRoomMessagesCalledCount >= 1 && MockChatAPIService.getChatRoomMessagesCalledCount < 5 {
      return PND.ChatMessagesModel(
        hasNext: true,
        hasPrev: true,
        next: nil,
        prev: nil,
        items: MockChatAPIService.getChatRoomMessagesCalledCount % 2 == 0 ? Array(chatRoomMessages[10..<15]) : Array(chatRoomMessages[15..<20])
      )
    } else {
      return PND.ChatMessagesModel(
        hasNext: true,
        hasPrev: true,
        next: nil,
        prev: nil,
        items: []
      )
    }
  }
  
  private static var getChatRoomMessagesCalledCount = 0
  private let chatRoomMessages: [PND.ChatMessages] = [
    PND.ChatMessages(
      content: "안녕 메시지 테스트야11",
      createdAt: "1726472095",
      id: "12",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테스트야22",
      createdAt: "1726472095",
      id: "123",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테스트야33",
      createdAt: "1726472095",
      id: "1234",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테스트야44",
      createdAt: "1726472095",
      id: "1223",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테스트야55",
      createdAt: "1726472095",
      id: "12223",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테스트야66",
      createdAt: "1726472095",
      id: "1",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테스트야77",
      createdAt: "1726472095",
      id: "2",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테스트야88",
      createdAt: "1726472095",
      id: "3",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테스adsfasdfasd트야99",
      createdAt: "1726472095",
      id: "4",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테스트xcvzcvzxcv10",
      createdAt: "1726472095",
      id: "5",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테스sdfadsf트야11",
      createdAt: "1726472095",
      id: "6",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테zzzz스트야12",
      createdAt: "1726472095",
      id: "7",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테스트2222야13",
      createdAt: "1726472095",
      id: "8",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테스트야14",
      createdAt: "1726472095",
      id: "9",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테asdfa스트야15",
      createdAt: "1726472095",
      id: "10",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테스트a야16",
      createdAt: "1726472095",
      id: "11",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테스트dfd야17",
      createdAt: "1726472095",
      id: "12",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테fff스트야18",
      createdAt: "1726472095",
      id: "13",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테스트야19",
      createdAt: "1726472095",
      id: "14",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
    PND.ChatMessages(
      content: "안녕 메시지 테스dd트야20",
      createdAt: "1726472095",
      id: "15",
      messageType: PND.MessageType.plain.rawValue,
      roomId: "1",
      userId: "12"
    ),
  ]
}
