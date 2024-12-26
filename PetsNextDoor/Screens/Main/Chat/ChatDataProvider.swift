//
//  ChatDataProvider.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 6/17/24/

import Foundation
import PhotosUI
import SwiftUI

import Starscream


final class ChatDataProvider {
  
  enum Action: Equatable {
    case onConnect
    case onDisconnect
    case onReceiveNewChatType([ChatViewType])
  }
  
  struct Configuration {
    let roomId: String
  }
  
  private let configuration: Configuration
  
  private var chatSocketService: any ChatServiceProvidable
  private var chatAPIService: any ChatAPIServiceProvidable
  
  // Jin - ???: 두개 따로 관리하는게 맞나...
  private(set) var chatModels: [TempChatModel] = []
  private(set) var chatViewTypes: [ChatViewType] = []
  
  private var continuation: AsyncStream<Action>.Continuation!
  
  init() {
    self.configuration = Configuration(roomId: "01940277-6e44-7ab9-91da-d46d0d05e33c")
    var request = URLRequest(url: URL(string: "https://pets-next-door.fly.dev/api/chat/ws")!)
    request.setValue(PNDTokenStore.shared.accessToken, forHTTPHeaderField: "Authorization")
    let socket = WebSocket(request: request)
    self.chatSocketService = LiveChatService(
      socket: socket,
      mediaService: MediaService(),
      configuration: .init(roomId: configuration.roomId)
    )
//    self.chatSocketService = LiveChatService(
//      socket: MockWebSocket(),
//      mediaService: MediaService(),
//      configuration: .init(roomId: configuration.roomId)
//    )
    self.chatAPIService = ChatAPIService()
    chatSocketService.delegate = self
  }
  
  func fetchRoomInfo() async throws -> PND.ChatRoomModel {
    return try await chatAPIService.getChatRoom(roomId: configuration.roomId)
  }
  
  func fetchOldChats(size: Int = 20) async throws -> [ChatViewType] {
    let fetchedOldChats = try await chatAPIService
      .getChatRoomMessages(roomId: configuration.roomId, prev: chatModels.first?.messageID, next: nil, size: size)
      .items
      .map { $0.tempChatModel }
      .reversed()
    let oldChatViewTypes = await fetchedOldChats
      .asyncMap { await self.newChatViewType(from: $0) }
      .compactMap { $0 }
    self.chatModels = fetchedOldChats + chatModels
    self.chatViewTypes = oldChatViewTypes + chatViewTypes
    return self.chatViewTypes
  }
  
  func observeChatActionStream() -> AsyncStream<Action> {
    return AsyncStream<Action> { continuation in
      continuation.onTermination = { [weak self] _ in
        self?.chatSocketService.disconnect()
      }
      
      self.continuation = continuation
      chatSocketService.connect()
    }
  }
  
  func sendChat(text: String) async {
    await chatSocketService.sendMessage(text)
  }
  
  func sendImages(withPhotosPickerItems items: [PhotosPickerItem]) async throws {
    try await chatSocketService.sendImages(withPhotosPickerItems: items)
  }
  
  private func newChatViewType(from chatModel: TempChatModel) async -> ChatViewType? {
    let myUserId: String      = await UserDataCenter.shared.userProfileModel?.id ?? "1" // Jin - !!!: userProfileModel이 옵셔널 아니여야 할듯
    let senderUserId: String  = chatModel.userID
    let isMyChat: Bool        = myUserId == senderUserId
    
    let topSpace: CGFloat
    
    if let lastChatModel = chatModels.last {
      if lastChatModel.userID == myUserId { // 마지막 채팅이 내가 보낸 채팅이면
        topSpace = 4.0
      } else { // 마지막 채팅이 상대방이 보낸 채팅이면
        topSpace = 20.0
      }
    } else {  // 첫번째 말풍선인 경우
      topSpace = 4.0
    }
    
    let chatViewType: ChatViewType?
    
    switch chatModel.messageType {
      
    case PND.MessageType.plain.rawValue:
      chatViewType = ChatViewType.text(
        ChatTextBubbleViewModel(
          body: chatModel.message,
          isMyChat: isMyChat
        ),
        topSpace: topSpace
      )
      
      // Jin - TODO: 통합 챗모델 완료돼서 media프로퍼티 추가되면 주석 해제
//    case PND.MessageType.media.rawValue:
//      if tempChatModel.medias.count == 1, let firstMedia = tempChatModel.medias.first {
//        chatViewType = ChatViewType.singleImage(
//          SingleChatImageViewModel(
//            media: firstMedia,
//            isMyChat: isMyChat
//          ),
//          topSpace: topSpace
//        )
//      } else if tempChatModel.medias.count >= 2 {
//        chatViewType = ChatViewType.multipleImages(
//          MultipleChatImageViewModel(
//            medias: tempChatModel.medias,
//            isMyChat: isMyChat
//          ),
//          topSpace: topSpace
//        )
//      } else {
//        chatViewType = nil
//      }
      
    default:
      chatViewType = nil
    }
    
    return chatViewType
  }
}


extension ChatDataProvider: ChatServiceDelegate {
  
  func onConnect() {
    continuation.yield(.onConnect)
  }
  
  func onDisconnect() {
    continuation.yield(.onDisconnect)
  }
  
  func onReceiveNewUser() {
    
  }
  
  func onReceiveNewText(_ chatModel: PND.ChatModel) {
    Task {
      await appendNewChat(chatModel)
      continuation.yield(.onReceiveNewChatType(self.chatViewTypes))
    }
  }
  
  private func appendNewChat(_ chatModel: PND.ChatModel) async {
    let chatModel = chatModel.tempChatModel
    let newChatViewType = await newChatViewType(from: chatModel)
    chatModels.append(chatModel)
    if let newChatViewType {
      chatViewTypes.append(newChatViewType)
    }
  }
}

// MARK: - TempChatModel

struct TempChatModel {
  let userID: String
  let roomID: String
  let messageID: String
  let message: String
  let messageType: String
}

extension PND.ChatModel {
  var tempChatModel: TempChatModel {
    TempChatModel(
      userID: self.sender?.id ?? "1",
      roomID: self.room.id,
      messageID: self.messageId,
      message: self.message,
      messageType: self.messageType
    )
  }
}

extension PND.ChatMessages {
  var tempChatModel: TempChatModel {
    TempChatModel(
      userID: self.userId,
      roomID: self.roomId,
      messageID: self.id,
      message: self.content,
      messageType: self.messageType
    )
  }
}
