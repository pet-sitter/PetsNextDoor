//
//  ServiceError.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/23.
//

import Foundation

extension PND {
  
  enum ServiceError: Error {

    case uploadImageFailed
    
    case unknown
    
    var errorMessage: String {
      switch self {
        
      case .uploadImageFailed: return "이미지 업로드에 실패하였어요."
        
      case .unknown: return "알 수 없는 오류가 발생했어요. 잠시 후 다시 시도해주세요."
      default: return "알 수 없는 오류가 발생했어요. 잠시 후 다시 시도해주세요."
      }
    }
  }
  
}
