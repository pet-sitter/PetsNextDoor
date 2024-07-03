//
//  SocketManager.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 6/15/24.
//

import Foundation
import Combine
import SocketIO


protocol ChatServiceProvidable {
	
	func connect()
  
  var delegate: (any ChatServiceDelegate)? { get set }
}

protocol SocketServiceProvidable {
	
	var socket: SocketIOClient { get }
	
	init(socketURL: URL)
	
	func connect()
	func disconnect()
}

protocol ChatServiceDelegate: AnyObject {
	
	func onConnect()
	func onDisconnect()
  func onReceiveNewUser()
	func onReceiveNewChat(_ chatModel: PND.ChatModel)
  
}


extension PND {
	struct ChatModel: Codable {
		
		var id: String = UUID().uuidString
		
		let textBody: String
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
	
	private func beginGeneratingMockChatMessages() {
		
		timerSubscription = Timer
			.publish(every: 2.5, on: .main, in: .common)
			.autoconnect()
			.sink { [weak self] _ in
				self?.delegate?.onReceiveNewChat(
					PND.ChatModel(
						textBody: MockDataProvider.chatBubbleViewModels
							.map(\.body)
							.randomElement()!
					)
				)
			}
		
		delegate?.onConnect()
	}
	
	func stopGeneratingMockChatMessages() {
		timerSubscription?.cancel()
		timerSubscription = nil
	}
}





final class LiveChatService: ChatServiceProvidable, SocketServiceProvidable {
  
  private(set) var socketManager: SocketManager
  private(set) var socket: SocketIOClient
  
  weak var delegate: (any ChatServiceDelegate)?
  
  init(socketURL: URL) {
    self.socketManager = SocketManager(socketURL: socketURL)
    self.socket        = self.socketManager.defaultSocket
  }
  

  
  func connect() {
    observeSocketEvents()
  }
  
  func disconnect() {
    
  }
  
  func sendMessage(_ message: String) {
    
  }
  
  private func observeSocketEvents() {
    
    socket.on("receiveMessage") { [weak self] data, _ in
      
		
      
//      self?.delegate?.onReceiveNewChat()
    }
    
    socket.on("receiveNewUser") { [weak self] data, _ in
      self?.delegate?.onReceiveNewUser()
    }
  }
  
}

//
//
//class ChatClient2: NSObject {
//  static let shared = ChatClient()
//  
//  var manager: SocketManager!
//  var socket: SocketIOClient!
//  var username: String!
//  
//  override init() {
//    super.init()
//    
//    manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!)
//    socket = manager.defaultSocket
//  }
//  
//  func connect(username: String) {
//    self.username = username
//    socket.connect(withPayload: ["username": username])
//  }
//  
//  func disconnect() {
//    socket.disconnect()
//  }
//  
//  func sendMessage(_ message: String) {
//    socket.emit("sendMessage", message)
//  }
//  
//  func sendUsername(_ username: String) {
//    socket.emit("sendUsername", username)
//  }
//  
//  func receiveMessage(_ completion: @escaping (String, String, UUID) -> Void) {
//    socket.on("receiveMessage") { data, _ in
//      if let text = data[2] as? String,
//         let id = data[0] as? String,
//         let username = data[1] as? String {
//        completion(username, text, UUID.init(uuidString: id) ?? UUID())
//      }
//    }
//  }
//  
//  func receiveNewUser(_ completion: @escaping (String, [String:String]) -> Void) {
//    socket.on("receiveNewUser") { data, _ in
//      if let username = data[0] as? String,
//         let users = data[1] as? [String:String] {
//        completion(username, users)
//      }
//    }
//  }
//}


//
//      ChatClient.shared.connect(username: "kevinkim2586")
//          ChatClient.shared.receiveMessage { username, text, id in
//            print("✅ receiveMessage: \(username)")
////              self.receiveMessage(username: username, text: text, id: id)
//          }
//          ChatClient.shared.receiveNewUser { username, users in
//            print("✅ receiveNewUser: \(username)")
////              self.receiveNewUser(username: username, users: users)
//          }
