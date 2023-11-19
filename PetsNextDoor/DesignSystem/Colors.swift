//
//  Colors.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/30.
//

import UIKit

extension PND {
  
  enum Colors {
    static let commonBlack 	= UIColor.black
		static let commonWhite 	= UIColor.white
		static let commonOrange = UIColor(hex: "FF8B00")
    static let commonGrey   = UIColor(hex: "#D9D9D9")
    
    static let commonBlue = UIColor(hex: "6A9DFF")
  }
}

extension UIColor {
  static var color = PND.Colors.self
}
