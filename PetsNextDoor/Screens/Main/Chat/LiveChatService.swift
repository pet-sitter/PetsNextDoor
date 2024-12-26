//
//  SocketManager.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 6/15/24.
//

import Foundation
import Combine
import PhotosUI
import SwiftUI

import Starscream


// MARK: - ChatService

protocol ChatServiceProvidable {
  
  var delegate: (any ChatServiceDelegate)? { get set }
  
  func connect()
  func disconnect()
  func sendMessage(_ message: String) async
  func sendImages(withPhotosPickerItems items: [PhotosPickerItem]) async throws
}

protocol ChatServiceDelegate: AnyObject {
  
  func onConnect()
  func onDisconnect()
  func onReceiveNewUser()
  func onReceiveNewText(_ chatModel: PND.ChatModel)
}

// MARK: - SocketService

protocol SocketServiceProvidable: WebSocketDelegate {
  
  associatedtype Configuration
  
  var socket: any PNDWebSocketClient { get }
  var configuration: Configuration { get }
  init(socket: any PNDWebSocketClient, mediaService: any MediaServiceProvidable, configuration: Configuration)
}

protocol PNDWebSocketClient: WebSocketClient & WebSocketDelegateProvidable {}

protocol WebSocketDelegateProvidable {
  var delegate: (any WebSocketDelegate)? { get set }
}

extension WebSocket: PNDWebSocketClient {}


// MARK: -

final class LiveChatService: ChatServiceProvidable, SocketServiceProvidable {
  
  struct Configuration {
    let roomId: String
  }
  
  private(set) var socket: any PNDWebSocketClient
  private(set) var configuration: Configuration
  private let mediaService: any MediaServiceProvidable
  
  weak var delegate: (any ChatServiceDelegate)?
  
  @Published private(set) var isConnected: Bool = false
  
  init(
    socket: any PNDWebSocketClient,
    mediaService: any MediaServiceProvidable,
    configuration: Configuration
  ) {
    self.socket = socket
    self.mediaService = mediaService
    self.configuration = configuration
    
    self.socket.delegate = self
  }
  
  func didReceive(event: WebSocketEvent, client: any WebSocketClient) {
    print("✅ WEBSOCKET event received: \(event)")
    
    switch event {
    case .connected(let headers):
      isConnected = true
      
    case .text(let chatReceived):
      
      guard
        let data = chatReceived.data(using: .utf16),
        let chatModel = try? JSONDecoder().decode(PND.ChatModel.self, from: data)
      else {
        PNDLogger.`default`.error("onReceiveNewText error decoding chat text ")
        return
      }
      
      delegate?.onReceiveNewText(chatModel)
      
    case .disconnected(let reason, let code):
      isConnected = false
      delegate?.onDisconnect()
      
    case .binary(let data):
      break
      
    case .ping(_):
      break
      
    case .pong(_):
      break
      
    case .viabilityChanged(_):
      break
      
    case .reconnectSuggested(_):
      break
      
    case .cancelled:
      isConnected = false
      
    case .error(let error):
      isConnected = false
      
      
    case .peerClosed:
      break
      
    }
  }
  
  func connect() {
    socket.connect()
  }
  
  func disconnect() {
    socket.disconnect()
  }
  
  // Jin - TODO: UserDataCenter 때문에 async로 했는데 더 나은 방법 찾아보기
  func sendMessage(_ message: String) async {
    let myUserID = await UserDataCenter.shared.userProfileModel?.id ?? "1"
    let chatRequestModel: PND.ChatModel = PND.ChatModel(
//      sender: PND.Sender(id: myUserID), // Jin - TODO: 없애야 함. Mock에서는 필요하고 실제에서는 필요 없음. Mock에서 sender id 첨부해서 던지도록 Mock 수정하기.
      room: PND.Room(id: configuration.roomId),
      messageType: PND.MessageType.plain.rawValue,
      message: message,
      messageId: UUID().uuidString,
      medias: []
    )
    
    guard
      let encodedModel = try? JSONEncoder().encode(chatRequestModel),
      let chatJSON = String(data: encodedModel, encoding: .utf8)
    else {
      PNDLogger.`default`.error("sendMessage error encoding message")
      return
    }
    
    socket.write(string: chatJSON)
  }
  
  func sendImages(withPhotosPickerItems items: [PhotosPickerItem]) async throws {
    let medias = try await uploadImages(withPhotosPickerItems: items)
    let myUserID = await UserDataCenter.shared.userProfileModel?.id ?? "1"
    let chatRequestModel: PND.ChatModel = PND.ChatModel(
      sender: PND.Sender(id: myUserID),
      room: PND.Room(id: configuration.roomId),
      messageType: PND.MessageType.media.rawValue,
      message: "",
      messageId: UUID().uuidString,
      medias: medias
    )
    
    guard
      let encodedModel = try? JSONEncoder().encode(chatRequestModel),
      let chatJSON = String(data: encodedModel, encoding: .utf8)
    else {
      PNDLogger.`default`.error("sendImages error encoding message")
      return
    }
    
    socket.write(string: chatJSON)
  }
  
  private func uploadImages(withPhotosPickerItems items: [PhotosPickerItem]) async throws -> [PND.Media] {
    var imageDatas: [Data] = []
    
    for item in items {
      let imageData = await PhotoConverter.getImageData(fromPhotosPickerItem: item)
      
      if let imageData {
        imageDatas.append(imageData)
      }
    }
    
    let uploadResponseModel: [PND.UploadMediaResponseModel] = try await mediaService.uploadImages(imageDatas: imageDatas)
    
    return uploadResponseModel.map {
      PND.Media(
        id: $0.id,
        url: $0.url,
        createdAt: $0.createdAt,
        mediaType: $0.mediaType
      )
    }
  }
}


final class MockWebSocket: PNDWebSocketClient {
  
  var delegate: (any WebSocketDelegate)?
  private var timerSubscription: AnyCancellable?
  private let userSentWebSocketEventSubject: PassthroughSubject<WebSocketEvent, Never> = .init()
  
  func connect() {
    let randomTextPublisher = Timer
      .publish(every: 2.5, on: .main, in: .common)
      .autoconnect()
      .map { _ -> WebSocketEvent? in
        .text(MockDataProvider.textEvents.randomElement()!)
      }
      .compactMap { $0 }
    
    let resentPublisher = userSentWebSocketEventSubject
      .delay(for: .seconds(0.01), scheduler: DispatchQueue.main)
    
    timerSubscription = Publishers.Merge(randomTextPublisher, resentPublisher)
      .sink { [weak self] event in
        guard let self else { return }
        self.delegate?.didReceive(event: event, client: self)
      }
  }
  
  func disconnect(closeCode: UInt16 = 0) {
    timerSubscription?.cancel()
    timerSubscription = nil
  }
  
  func write(string: String, completion: (() -> ())?) {
    userSentWebSocketEventSubject.send(.text(string))
  }
  
  func write(stringData: Data, completion: (() -> ())?) {}
  func write(data: Data, completion: (() -> ())?) {}
  func write(ping: Data, completion: (() -> ())?) {}
  func write(pong: Data, completion: (() -> ())?) {}
}
