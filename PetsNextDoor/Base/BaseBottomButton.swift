//
//  BaseBottomButton.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/20.
//

import UIKit
import SnapKit

class BaseBottomButton: UIButton {

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
		setTitleColor(PND.Colors.commonWhite, for: .normal)
    titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
  }
}
