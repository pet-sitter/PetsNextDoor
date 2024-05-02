//
//  NumberConverter.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/05/02.
//

import Foundation

struct NumberConverter {
  
  static func convertToCurrency(_ targetString: String) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    
    if let formattedNumber = numberFormatter.string(from: NSNumber(value: Int(targetString) ?? 0)) {
      return formattedNumber
    } else {
      return targetString
    }
  }
}
