//
//  ChatAPIService.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 9/16/24.
//

import Foundation

protocol ChatAPIServiceProvidable: PNDNetworkProvidable {
  
}

struct ChatAPIService: ChatAPIServiceProvidable {
  
  private(set) var network: PND.Network<PND.API> = .init()
  
  typealias Network = PND.Network<PND.API>
  
  // 사용자의 채팅방 목록 조회
  func getChatRooms() {
    
  }
  
  // 채팅방 생성
  func postChatRoom() {
    
  }
  
  // 채팅방 조회
  func getChatRoom(roomId: Int) {
    
  }
  
  // 채팅방 참가
  func joinChatRoom(roomId: Int) {
    
  }
  
  // 채팅방 나가기
  func leaveChatRoom(roomId: Int) {
    
  }
  
  // 채팅방 메시지 조회
  func getChatRoomMessages(
    roomId: Int,
    prev: Int? = nil,
    next: Int? = nil,
    size: Int = 30
  ) {
    
  }
}
