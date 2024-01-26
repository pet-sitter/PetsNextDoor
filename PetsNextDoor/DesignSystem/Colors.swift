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
  
  static var commonOrange: Self {
    PND.Colors.commonOrange.asColor
  }
  
  static var commonGrey: Self {
    PND.Colors.commonGrey.asColor
  }
  
  static var primary: Self {
    PND.Colors.primary.asColor
  }
  
  static var yellowGreen: Self {
    PND.Colors.yellowGreen.asColor
  }
  
  static var lightGreen: Self {
    PND.Colors.lightGreen.asColor
  }
  
  static var gray90: Self {
    PND.Colors.gray90.asColor
  }
  
  static var gray50: Self {
    PND.Colors.gray50.asColor
  }
  
  static var gray30: Self {
    PND.Colors.gray30.asColor
  }
  
  static var gray20: Self {
    PND.Colors.gray20.asColor
  }
  
  static var gray10: Self {
    PND.Colors.gray10.asColor
  }
  
  static var commonBlue: Self {
    PND.Colors.commonBlue.asColor
  }
  
  static var commonRed: Self {
    PND.Colors.commonRed.asColor
  }
  
  static var commonBlack: Self {
    PND.Colors.commonBlack.asColor
  }
  
  static var commonWhite: Self {
    PND.Colors.commonWhite.asColor
  }
}

