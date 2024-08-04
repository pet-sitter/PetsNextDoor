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
  
  private(set) var chatModels: [PND.ChatModel] = []
	
	private var continuation: AsyncStream<Action>.Continuation!
	
  init() {
    self.chatService = LiveChatService(
      socketURL: URL(string: "https://pets-next-door.fly.dev/api/chat/ws")!,
      configuration: .init(roomId: 1)
    )
    chatService.delegate = self
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
    
    
    
    
    
    chatService.sendMessage(text)
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
      
      let myUserId: Int     = await UserDataCenter.shared.userProfileModel?.id ?? 0
      let senderUserId: Int = chatModel.sender?.id ?? 0
      
      await MainActor.run {
        var chatViewTypes: [ChatViewType] = []
        
        if let lastChatModel = chatModels.last {
          chatViewTypes.append(ChatViewType.spacer(height: 10))
        } else {  // 첫번째 말풍선인 경우
          chatViewTypes.append(ChatViewType.spacer(height: 4))
        }
        
        chatViewTypes.append(ChatViewType.text(
          ChatTextBubbleViewModel(
            body: chatModel.message,
            isMyChat: myUserId == senderUserId
          )
        ))
        
        chatModels.append(chatModel)

        continuation.yield(.onReceiveNewChatType(chatViewTypes))
      }
    }
  }
}

