//
//  UINavigationController+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/12.
//

import UIKit
import SwiftUI

extension UINavigationController: UIGestureRecognizerDelegate {
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
  
  
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
