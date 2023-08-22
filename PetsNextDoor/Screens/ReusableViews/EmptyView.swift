//
//  EmptyView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/05.
//

import UIKit

final class EmptyView: UIView {
  
  private(set) var height: CGFloat = 10
  
  private var containerView: UIView!
  
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  convenience init(height: CGFloat) {
    self.init()
    self.height = height
  }
  
  @available(*, unavailable) required init?(coder: NSCoder) { fatalError("Not implemented") }
  
  private func configureUI() {
    
    containerView = UIView()
    containerView.set {
      addSubview($0)
      $0.backgroundColor = .white
      $0.snp.makeConstraints {
        $0.center.equalToSuperview()
        $0.width.equalTo(UIScreen.fixedScreenSize.width)
        $0.height.equalTo(height)
      }
    }
  }
}
