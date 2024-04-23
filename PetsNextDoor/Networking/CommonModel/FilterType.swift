//
//  FilterType.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/04/22.
//

import Foundation

extension PND {
  
  enum SortOption: String, CaseIterable, Codable {
    case newest   = "newest"
    case deadline = "deadline"
    
    var description: String {
      switch self {
      case .newest:   "최신순"
      case .deadline: "마감순"
      }
    }
  }
}

extension PND {
  
  enum FilterType: String, CaseIterable, Codable, Equatable {
    case onlyDogs = "dog"
    case onlyCats = "cat"
    case all      = "all"
    
    var description: String {
      switch self {
      case .onlyDogs:     "강아지만"
      case .onlyCats:     "고양이만"
      case .all: "상관없음"
      }
    }
  }
}
