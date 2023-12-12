//
//  UINavigationController+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/12.
//

import UIKit
import SwiftUI

extension UINavigationController {
  
  func presentSwiftUIView(view: some View, animated: Bool, style: UIModalPresentationStyle) {
    let hostView = UIHostingController(rootView: view)
    hostView.modalPresentationStyle = style
    self.present(hostView, animated: animated)
  }
  
  func pushSwiftUIView(view: some View, animated: Bool, style: UIModalPresentationStyle = .fullScreen) {
    let hostView = UIHostingController(rootView: view)
    hostView.modalPresentationStyle = style
    self.pushViewController(hostView, animated: animated)
  }
}
