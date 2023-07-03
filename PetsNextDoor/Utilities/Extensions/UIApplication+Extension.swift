//
//  UIApplication+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/06/25.
//

import UIKit

extension UIApplication {
  
  static func topViewController(
    base: UIViewController? = UIWindow.key?.rootViewController
  ) -> UIViewController? {
      if let nav = base as? UINavigationController {
          return topViewController(base: nav.visibleViewController)
      } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
          return topViewController(base: selected)
      } else if let presented = base?.presentedViewController {
          return topViewController(base: presented)
      }
      return base
  }
}
