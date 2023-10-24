//
//  ComponentRenderable.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/24.
//

import UIKit
import SnapKit

protocol ComponentRenderable: AnyObject {
  /// Component를 렌더링하기 위한 containerView
  var containerView: UIView { get }
  
  func render(component: some Component)
}


extension ComponentRenderable where Self: UIView {
  var containerView: UIView { self }
}

extension ComponentRenderable where Self: UITableViewCell {
  var containerView: UIView { contentView }
}
