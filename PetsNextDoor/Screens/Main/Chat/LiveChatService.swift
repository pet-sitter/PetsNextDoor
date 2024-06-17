//
//  SocketManager.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 6/15/24.
//

import Foundation
import SocketIO


protocol ChatServiceProvidable {
  
  var delegate: (any ChatServiceDelegate)? { get set }
  

}

protocol ChatServiceDelegate: AnyObject {
  func onReceiveNewUser()
  func onReceiveMessage()
  
}


final class LiveChatService: ChatServiceProvidable {
  
  private let socketManager: SocketManager
  private let socket: SocketIOClient
  
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
      
      
      
      
      
      
      
      
      self?.delegate?.onReceiveMessage()
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
