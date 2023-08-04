//
//  BaseBottomButton.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/20.
//

import UIKit
import Combine

class BaseBottomButton: UIButton, Touchable {
  
  static let defaultHeight: CGFloat = 60

  override var isEnabled: Bool {
    didSet { backgroundColor = isEnabled ? PND.Colors.commonBlack : .init(hex: "#D1D1D1") }
  }
  
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  convenience init(title: String) {
    self.init()
    setTitle(title, for: .normal)
  }
  
  @available(*, unavailable) required init?(coder: NSCoder) { fatalError("Not implemented") }

  private func configureUI() {
    backgroundColor     = .black
    clipsToBounds       = true
    layer.cornerRadius  = 4
    setTitleColor(.white, for: .normal)
    titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    
    self.onTapGesture { [weak self] in
      self?.onTouchableAreaTap {}
    }
  }
  
  func onTouchableAreaTap(_ action: @escaping () -> Void) {
    
  }
}
