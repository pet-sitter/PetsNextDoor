//
//  ChatModel.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 7/29/24.
//

import Foundation

extension PND {
  
  enum MessageType: String {
    case plain = "plain"
    case media = "media"
  }
  
  struct ChatModel: Codable {
    
    var sender: Sender?
    let room: Room
    let messageType: String // 추후 enum으로 변경
    let message: String
    @DefaultEmptyString var messageId: String
    @DefaultEmptyArray var medias: [Media]
    var createdAt: String?
    var updatedAt: String?
  }

  struct Room: Codable {
    let id: String
  }
  
  struct Media: Codable, Equatable {
    let id: String
    var url: String?
    var createdAt: String?
    let mediaType: String? 
  }
  
  
  
  struct Sender: Codable {
    let id: String
  }
}


/**
 REQUEST
 {
     "room": {
         "id": 1
     },
     "messageType": "plain",
     "message": "hello"
 }
 
 RESPONSE
 
 {
     "user": {
         "id": 1
     },
     "room": {
         "id": 1
     },
     "messageType": "plain",
     "message": "hello",
     "createdAt": "2024-07-28T15:56:14",
     "updatedAt": "2024-07-28T15:56:14"
 }
 
 */
