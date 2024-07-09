//
//  ChatDataProvider.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 6/17/24/

import Foundation

final class ChatDataProvider {
  
  enum Action: Equatable {
    case onConnect
    case onDisconnect
    case onReceiveNewChatType([ChatViewType])
  }

  private var chatService: any ChatServiceProvidable
  
  
  
  private var chatModels: [PND.ChatModel] = []
	
	private var continuation: AsyncStream<Action>.Continuation!
	
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
  
  func sendChat(text: String) {
    
    let newChatModel: PND.ChatModel = PND.ChatModel(textBody: text, isMyChat: true)
    
    var chatViewTypes: [ChatViewType] = []
    
    if let lastChatModel = chatModels.last {
      if lastChatModel.isMyChat == newChatModel.isMyChat {
        chatViewTypes.append(ChatViewType.spacer(height: 4))
      } else {
        chatViewTypes.append(ChatViewType.spacer(height: 10))
      }
    } else { // 첫번째 Chat
      chatViewTypes.append(ChatViewType.spacer(height: 4))
    }
    
    
    chatViewTypes.append(ChatViewType.text(
      ChatTextBubbleViewModel(
        body: newChatModel.textBody,
        isMyChat: newChatModel.isMyChat
      )
    ))
    
    chatModels.append(newChatModel)
    
    
    continuation.yield(.onReceiveNewChatType(chatViewTypes))
    
  }
}

// Utility Methods

extension ChatDataProvider {
  

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

    var chatViewTypes: [ChatViewType] = []
    
    if let lastChatModel = chatModels.last {
      if lastChatModel.isMyChat == chatModel.isMyChat {
        chatViewTypes.append(ChatViewType.spacer(height: 4))
      } else {
        chatViewTypes.append(ChatViewType.spacer(height: 10))
      }
    } else { // 첫번째 Chat
      chatViewTypes.append(ChatViewType.spacer(height: 4))
    }
  
    chatViewTypes.append(ChatViewType.text(
      ChatTextBubbleViewModel(
        body: chatModel.textBody,
        isMyChat: chatModel.isMyChat
      )
    ))
    
    self.chatModels.append(chatModel)

		continuation.yield(.onReceiveNewChatType(chatViewTypes))
  }
}

