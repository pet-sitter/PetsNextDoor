//
//  ChatDataProvider.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 6/17/24/

import Foundation
import PhotosUI
import _PhotosUI_SwiftUI

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
  private let mediaService: any MediaServiceProvidable
  
  private(set) var chatModels: [PND.ChatModel] = []
  
  private var continuation: AsyncStream<Action>.Continuation!
  
  init() {
    self.configuration = Configuration(roomId: "f5e17d20-5688-4924-b6c7-4509e80f04ad")
//    self.chatSocketService = LiveChatService(
//      socketURL: URL(string: "https://pets-next-door.fly.dev/api/chat/ws")!,
//      configuration: .init(roomId: configuration.roomId)
//    )
    self.chatSocketService = MockLiveChatService()
    self.chatAPIService = ChatAPIService()
    self.mediaService = MediaService()
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
  
  func sendChat(text: String) {
    chatSocketService.sendMessage(text)
  }
  
  func sendImages(withPhotosPickerItems items: [PhotosPickerItem]) async throws {
    var imageDatas: [Data] = []
    
    for item in items {
      let imageData = await PhotoConverter.getImageData(fromPhotosPickerItem: item)
      
      if let imageData {
        imageDatas.append(imageData)
      }
    }
    
    let uploadResponseModel: [PND.UploadMediaResponseModel] = try await mediaService.uploadImages(imageDatas: imageDatas)
    let mediaIds: [String] = uploadResponseModel.map(\.id)
    
    chatSocketService.sendImages(mediaIds: mediaIds)
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
    _Concurrency.Task {
      
      let myUserId: String      = await UserDataCenter.shared.userProfileModel?.id ?? "1"
      let senderUserId: String  = chatModel.sender?.id ?? "0"
      let isMyChat: Bool        = myUserId == senderUserId
      
      await MainActor.run {
        var chatViewTypes: [ChatViewType] = []
        
        if let lastChatModel = chatModels.last {
          
          if lastChatModel.sender?.id == myUserId { // 마지막 채팅이 내가 보낸 채팅이면
            chatViewTypes.append(ChatViewType.spacer(height: 4))
          } else { // 마지막 채팅이 상대방이 보낸 채팅이면
            chatViewTypes.append(ChatViewType.spacer(height: 20))
          }
          
        } else {  // 첫번째 말풍선인 경우
          chatViewTypes.append(ChatViewType.spacer(height: 4))
        }
        
        switch chatModel.messageType {
          
        case PND.MessageType.plain.rawValue:
          chatViewTypes.append(ChatViewType.text(
            ChatTextBubbleViewModel(
              body: chatModel.message,
              isMyChat: myUserId == senderUserId
            )
          ))
          
        case PND.MessageType.media.rawValue:
          if chatModel.medias.count == 1, let firstMedia = chatModel.medias.first {
            chatViewTypes.append(ChatViewType.singleImage(SingleChatImageViewModel(
              media: firstMedia,
              isMyChat: isMyChat
            )))
          } else if chatModel.medias.count >= 2 {
            chatViewTypes.append(ChatViewType.multipleImages(MultipleChatImageViewModel(
              medias: chatModel.medias,
              isMyChat: isMyChat
            )))
          }
          
        default:
          break
        }
        // Jin - ???: 아래 부분만 serial하게 일어나면 되지않을까?
        chatModels.append(chatModel)
        // Jin - 이 부분은 받는 쪽에서 await으로 어짜피 처리되니깐 serial안해도될거같고..
        continuation.yield(.onReceiveNewChatType(chatViewTypes))
      }
    }
  }
}
