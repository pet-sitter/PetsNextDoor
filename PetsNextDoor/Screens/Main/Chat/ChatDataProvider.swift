//
//  ChatDataProvider.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 6/17/24/

import Foundation

protocol ChatDataProvidable {
  
}

final class ChatDataProvider: ChatDataProvidable {
  
  private var chatService: any ChatServiceProvidable
  
  init() {
//    self.chatService = LiveChatService(
//      socketURL: URL(string: "http://localhost:3000")!
//    )
		self.chatService = MockLiveChatService()
    self.chatService.delegate = self
  }
}

extension ChatDataProvider: ChatServiceDelegate {
  
  func onReceiveNewUser() {
    
  }
  
	func onReceiveNewChat(_ chatModel: PND.ChatModel) {
    
  }
  
  
}

