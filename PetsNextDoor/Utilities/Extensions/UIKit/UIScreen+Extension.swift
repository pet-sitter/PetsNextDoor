//
//  UIScreen+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import UIKit

extension UIScreen {
  
  static var fixedScreenSize: CGSize {
    let screenSize  = UIScreen.main.bounds.size
    let width       = min(screenSize.width, screenSize.height)
    let height      = max(screenSize.width, screenSize.height)
    return CGSize(width: width, height: height)
  }
  
  static var safeAreaBottomInset: CGFloat {
    UIApplication.findKeyWindow()?
      .safeAreaInsets
      .bottom ?? 0
  }
  
  static var safeAreaTopInset: CGFloat {
    UIApplication.findKeyWindow()?
      .safeAreaInsets
      .top ?? 0
  }
  
}

