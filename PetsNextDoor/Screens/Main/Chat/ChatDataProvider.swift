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
  
  private(set) var chatModels: [PND.ChatModel] = []
  private(set) var chatViewTypes: [ChatViewType] = []
  
  private var continuation: AsyncStream<Action>.Continuation!
  
  init() {
    self.configuration = Configuration(roomId: "f5e17d20-5688-4924-b6c7-4509e80f04ad")
//    var request = URLRequest(url: URL(string: "https://pets-next-door.fly.dev/api/chat/ws")!)
//    request.setValue(PNDTokenStore.shared.accessToken, forHTTPHeaderField: "Authorization")
//    let socket = WebSocket(request: request)
//    self.chatSocketService = LiveChatService(
//      socket: socket,
//      mediaService: MediaService(),
//      configuration: .init(roomId: configuration.roomId)
//    )
    self.chatSocketService = LiveChatService(
      socket: MockWebSocket(),
      mediaService: MediaService(),
      configuration: .init(roomId: configuration.roomId)
    )
    self.chatAPIService = MockChatAPIService()
    chatSocketService.delegate = self
    chatSocketService.connect()
  }
  
  func fetchRoomInfo() async throws -> PND.ChatRoomModel {
    return try await chatAPIService.getChatRoom(roomId: configuration.roomId)
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
    chatModels.append(chatModel)
    
    let myUserId: String      = await UserDataCenter.shared.userProfileModel?.id ?? "1"
    let senderUserId: String  = chatModel.sender?.id ?? "0"
    let isMyChat: Bool        = myUserId == senderUserId
    
    var topSpace: CGFloat?
    
    if let lastChatModel = chatModels.last {
      if lastChatModel.sender?.id == myUserId { // 마지막 채팅이 내가 보낸 채팅이면
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
      
    case PND.MessageType.media.rawValue:
      if chatModel.medias.count == 1, let firstMedia = chatModel.medias.first {
        chatViewType = ChatViewType.singleImage(
          SingleChatImageViewModel(
            media: firstMedia,
            isMyChat: isMyChat
          ),
          topSpace: topSpace
        )
      } else if chatModel.medias.count >= 2 {
        chatViewType = ChatViewType.multipleImages(
          MultipleChatImageViewModel(
            medias: chatModel.medias,
            isMyChat: isMyChat
          ),
          topSpace: topSpace
        )
      } else {
        chatViewType = nil
      }
      
    default:
      chatViewType = nil
    }
    
    if let chatViewType {
      chatViewTypes.append(chatViewType)
    }
  }
}
