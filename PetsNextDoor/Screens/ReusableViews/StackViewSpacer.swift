//
//  StackViewSpacer.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/09.
//

import UIKit

final class StackViewSpacer: UIView {

  init() {
    super.init(frame: .zero)
    let constraint = self.widthAnchor.constraint(lessThanOrEqualToConstant: CGFloat.greatestFiniteMagnitude)
    constraint.isActive = true
    constraint.priority = .defaultLow
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
