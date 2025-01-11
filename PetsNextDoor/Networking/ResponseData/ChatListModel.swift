//
//  ChatListModel.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 9/16/24.
//

import Foundation

extension PND {
  
  struct ChatListModel: Codable, Equatable {
    @DefaultEmptyArray var items: [ChatRoomModel]
  }
  
  // 채팅방 방 정보
  struct ChatRoomModel: Codable, Equatable {
    let createdAt: String
    let id: String
    @DefaultEmptyArray var joinUsers: [JoinUser]
    let roomName: String
    let roomType: String
    let updatedAt: String?
  }
  
  struct JoinUser: Codable, Equatable {
    let profileImageUrl: String?
    let userId: String
    let userNickname: String?
  }
  
  struct ProfileImageId: Codable {
    let string: String
    let valid: Bool
  }
}



extension PND {
  
  // 채팅방 생성 후 오는 Response
  struct ChatCreationModel: Codable {
    @DefaultEmptyArray var joinUserIds: [String]
    let roomName: String
    let roomType: String
  }
}

extension PND {
  
 // 채팅방 메시지 조회 Data
  struct ChatMessagesModel: Codable {
    let hasNext: Bool
    let hasPrev: Bool
    let next: String?
    let prev: String?
    @DefaultEmptyArray var items: [ChatMessages]
  }
  
  struct ChatMessages: Codable {
    let content: String
    let createdAt: String
    let id: String
    let messageType: String
    let roomId: String
    let userId: String
  }
}
