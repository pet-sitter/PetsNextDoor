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
  
  static func findKeyWindow(activationStates: [UIScene.ActivationState] = [.foregroundActive]) -> UIWindow? {
      UIApplication.shared.connectedScenes
          .filter     { activationStates.contains($0.activationState) }
          .compactMap { $0 as? UIWindowScene }
          .first?
          .windows
          .filter { $0.isKeyWindow }
          .first
  }
}
