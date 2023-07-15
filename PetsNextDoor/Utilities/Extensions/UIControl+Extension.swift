//
//  UIAction+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/16.
//

import UIKit

extension UIControl {
  
  func onTap(_ actionBlock: (() -> Void)?) {
    let action = UIAction {  _ in actionBlock?()}
    self.addAction(action, for: .touchUpInside)
  }
  
}
