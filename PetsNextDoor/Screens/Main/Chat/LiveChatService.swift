//
//  SocketManager.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 6/15/24.
//

import Foundation
import Combine
import Starscream


protocol ChatServiceProvidable {
  
  var delegate: (any ChatServiceDelegate)? { get set }
	
	func connect()
  func sendMessage(_ message: String)
}

protocol SocketServiceProvidable: WebSocketDelegate {
	
  associatedtype Configuration
  
  var socket: WebSocket? { get }
  
  var configuration: Configuration { get }
	
  init(socketURL: URL, configuration: Configuration)
	
	func connect()
	func disconnect()
}


protocol ChatServiceDelegate: AnyObject {
	
	func onConnect()
	func onDisconnect()
  func onReceiveNewUser()
  func onReceiveNewText(_ chatModel: PND.ChatModel)
  
}



final class LiveChatService: ChatServiceProvidable, SocketServiceProvidable {
  
  struct Configuration {
    let roomId: Int
  }
  
  private(set) var socket: WebSocket?
  
  private(set) var configuration: Configuration
  
  weak var delegate: (any ChatServiceDelegate)?
  
  @Published private(set) var isConnected: Bool = false
  
  init(
    socketURL: URL,
    configuration: Configuration
  ) {
    self.configuration = configuration
    var request = URLRequest(url: socketURL)
    request.setValue(PNDTokenStore.shared.accessToken, forHTTPHeaderField: "Authorization")
//    request.setValue(
//      "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjFkYmUwNmI1ZDdjMmE3YzA0NDU2MzA2MWZmMGZlYTM3NzQwYjg2YmMiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoia2V2aW5raW0yNTg2IiwicGljdHVyZSI6Imh0dHA6Ly9rLmtha2FvY2RuLm5ldC9kbi9TRlN1Vy9idHNJTTdQVGx3RS9wZUgzVXFZaEtiNzh5bGVpZnNmNGwxL2ltZ182NDB4NjQwLmpwZyIsImlzcyI6Imh0dHBzOi8vc2VjdXJldG9rZW4uZ29vZ2xlLmNvbS9wZXRzbmV4dGRvb3ItNzg4YTAiLCJhdWQiOiJwZXRzbmV4dGRvb3ItNzg4YTAiLCJhdXRoX3RpbWUiOjE3MjI3NDE2NjcsInVzZXJfaWQiOiIzMzk4MDQ4Mjk5Iiwic3ViIjoiMzM5ODA0ODI5OSIsImlhdCI6MTcyMjc0MTY2NywiZXhwIjoxNzIyNzQ1MjY3LCJlbWFpbCI6Imtldmlua2ltMjU4NkBrYWthby5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsia2V2aW5raW0yNTg2QGtha2FvLmNvbSJdfSwic2lnbl9pbl9wcm92aWRlciI6ImN1c3RvbSJ9fQ.tnJdu_7Js20QDDmbjtG87w10VFOPI3yjaQUAGgTVN8TD4XGhO2n7C5uFpzlC5vfcsSEm07uV8JAKptu0d5--G8HADJdFDkucy89mLLBFsw9J4_F0sbI-4YJKd5Y-E_lGf6SPK3AUnMRxMW9bu9nWFpnjHU7CqClgQ3uY0Qrqxnz7qJMM1KRebaim57VLnsP88sZa9ot5mSWUq24bl0TjPWOgprSHC1_4PhRiGaapXo0yd1a8XRb-NgU5lGdyTbIHoKtTLZ_qBjgdcet2GCPyxR7HGl_HG2_Cay1csKq9ywuthNYQKvC8e6Eib_29q4h1VuraerWg-gDqzmpVm4Q-3g",
//      forHTTPHeaderField: "Authorization"
//    )
    socket = WebSocket(request: request)
    socket?.delegate = self
  }
  
  func didReceive(event: WebSocketEvent, client: any WebSocketClient) {
    print("✅ WEBSOCKET event received: \(event)")
    
    switch event {
    case .connected(let headers):
      isConnected = true
      
    case .text(let chatReceived):
      
      guard
        let data = chatReceived.data(using: .utf16),
        let chatModel = try? JSONDecoder().decode(PND.ChatModel.self, from: data) else {
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
    socket?.connect()
  }
  
  func disconnect() {
    socket?.disconnect()
  }
  
  func sendMessage(_ message: String) {
    
    let chatRequestModel: PND.ChatModel = PND.ChatModel(
      room: PND.Room(id: configuration.roomId),
      messageType: PND.MessageType.plain.rawValue,
      message: message
    )
    
    guard
      let encodedModel = try? JSONEncoder().encode(chatRequestModel),
      let chatJSON = String(data: encodedModel, encoding: .utf8)
    else {
      PNDLogger.`default`.error("sendMessage error encoding message")
      return
    }
    
    socket?.write(string: chatJSON)
  }
}




final class MockLiveChatService: ChatServiceProvidable {

  
  weak var delegate: (any ChatServiceDelegate)?
  
  private var timerSubscription: AnyCancellable?
  
  init() {
  }
  
  func connect() {
    beginGeneratingMockChatMessages()
  }
  
  func sendMessage(_ message: String) {
    
  }
  
  
  private func beginGeneratingMockChatMessages() {
    
    timerSubscription = Timer
      .publish(every: 3.5, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
//        self?.delegate?.onReceiveNewText(
//          MockDataProvider.chatBubbleViewModels.map(\.body).randomElement()!
//        )
      }
    
    delegate?.onConnect()
  }
  
  func stopGeneratingMockChatMessages() {
    timerSubscription?.cancel()
    timerSubscription = nil
  }
}
