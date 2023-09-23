//
//  UploadMediaResponseData.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/23.
//

import Foundation

//MARK: - 이미지 업로드 후 반환 모델

extension PND {
  struct UploadMediaResponseData: Codable {
    
    let createdAt: String
    let id: Int
    let mediaType: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
      case createdAt, id, mediaType, url
    }
  }
}
