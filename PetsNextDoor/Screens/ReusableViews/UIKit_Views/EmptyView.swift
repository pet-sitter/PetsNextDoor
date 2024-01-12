//
//  EmptyView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/05.
//

import UIKit

final class EmptyViewModel: HashableViewModel {
  let height: CGFloat
  let backgroundColor: UIColor
  
  init(height: CGFloat, backgroundColor: UIColor) {
    self.height = height
    self.backgroundColor = backgroundColor
  }
}

final class EmptyView: UIView {
  
  private(set) var height: CGFloat = 10
  private(set) var designedBackgroundColor: UIColor = PND.Colors.commonWhite
  
  private var containerView: UIView!
  
  init() {
    super.init(frame: .zero)
    configureUI()
  }

  @available(*, unavailable) required init?(coder: NSCoder) { fatalError("Not implemented") }
  
  private func configureUI() {
    
    containerView = UIView()
    containerView.set {
      addSubview($0)
      $0.snp.makeConstraints {
        $0.center.equalToSuperview()
        $0.width.equalTo(UIScreen.fixedScreenSize.width)
        $0.top.bottom.equalToSuperview()
        $0.height.equalTo(height)
      }
    }
  }
  
  func configure(viewModel: EmptyViewModel) {
    
    containerView.backgroundColor = viewModel.backgroundColor
    containerView.snp.updateConstraints {
      $0.height.equalTo(viewModel.height)
    }

  }
}
