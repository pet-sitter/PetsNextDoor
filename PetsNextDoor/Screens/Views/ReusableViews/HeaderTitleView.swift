//
//  HeaderTitleView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/30.
//

import UIKit
import SnapKit

final class HeaderTitleViewModel: HashableViewModel {
  let title: String
  let textAlignment: NSTextAlignment
  var font: UIFont? = nil
  
  init(title: String, textAlignment: NSTextAlignment, font: UIFont? = nil) {
    self.title = title
    self.textAlignment = textAlignment
    self.font = font
  }
}

final class HeaderTitleView: UIView {
  
  static let defaultHeight: CGFloat = 24
  
  private var titleLabel: UILabel!
  
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  private func configureUI() {
    
    titleLabel = UILabel()
    titleLabel.set {
      addSubview($0)
      $0.text = "제목"
      $0.font = .systemFont(ofSize: 20, weight: .bold)
      $0.snp.makeConstraints {
        $0.top.bottom.equalToSuperview()
        $0.leading.trailing.equalToSuperview().inset(PND.Metrics.defaultSpacing)
      }
    }
  }
  
  func configure(viewModel: HeaderTitleViewModel) {
    titleLabel.text = viewModel.title
    titleLabel.textAlignment = viewModel.textAlignment
    
    if let font = viewModel.font {
      titleLabel.font = font
    }
    titleLabel.setNeedsLayout()
  }
}
