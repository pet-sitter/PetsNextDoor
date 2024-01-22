//
//  Colors.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/30.
//

import UIKit
import SwiftUI

extension PND {
  
  enum Colors {

		static let commonOrange = UIColor(hex: "FF8B00")
    static let commonGrey   = UIColor(hex: "#D9D9D9")
    
    // Design System
    
    static let primary = UIColor(hex: "#10C200")
    static let yellowGreen = UIColor(hex: "B5E5A6")
    static let lightGreen = UIColor(hex: "E2F7E0")
    
    static let gray90 = UIColor(hex: "#333333")
    static let gray50 = UIColor(hex: "ACACAC")
    static let gray30 = UIColor(hex: "D9D9D9")
    static let gray20 = UIColor(hex: "F3F3F3")
    static let gray10 = UIColor(hex: "F9F9F9")
    
    static let commonBlue = UIColor(hex: "#6A9DFF")
    static let commonRed = UIColor(hex: "FF2727")
    static let commonBlack   = UIColor.black
    static let commonWhite   = UIColor.white
    
  }
}

extension UIColor {
  static var color = PND.Colors.self
  
  var asColor: SwiftUI.Color {
    return Color(self)
  }
}


extension Color {
  
	init(hex: String) {
		let uiColor = UIColor(hex: hex)
		self.init(uiColor)
	}
}
