//
//  ChatDataProvider.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 6/17/24/

import Foundation


final class ChatDataProvider {

  private var chatService: any ChatServiceProvidable
	
	
	enum Action: Equatable {
		case onConnect
		case onDisconnect
		case onReceiveNewChatType(ChatType)
	}
	
	var continuation: AsyncStream<Action>.Continuation!
	
  init() {
//    self.chatService = LiveChatService(
//      socketURL: URL(string: "http://localhost:3000")!
//    )
		self.chatService = MockLiveChatService()
    self.chatService.delegate = self
  }
	
	func observeChatActionStream() -> AsyncStream<Action> {
		let stream = AsyncStream<Action> { continuation in
			continuation.onTermination = { _ in
					// socket.cancel()
				
			}
			

			self.continuation = continuation
		}
		
		
		chatService.connect()
		
		
		return stream
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
  
	func onReceiveNewChat(_ chatModel: PND.ChatModel) {
		continuation.yield(
			.onReceiveNewChatType(
				ChatType.text(
					ChatTextBubbleViewModel(
						body: "123213",
						isMyChat: true
					)
				)
			)
		)
  }
}

