//
//  BaseBottomButton.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/20.
//

import UIKit
import SnapKit
import Combine

final class BaseBottomButtonViewModel: HashableViewModel {
  
  @Published var isEnabled: Bool = false
  let buttonTitle: String

  init(isEnabled: any SingleValuePublisher<Bool>, buttonTitle: String) {
    self.buttonTitle = buttonTitle
    isEnabled.assign(to: &$isEnabled)
  }
  
  init(isEnabled: Bool, buttonTitle: String) {
    self.isEnabled = isEnabled
    self.buttonTitle = buttonTitle
  }
}

class BaseBottomButton: UIButton {

  static let defaultHeight: CGFloat = 60

  override var isEnabled: Bool {
    didSet { backgroundColor = isEnabled ? PND.Colors.commonBlack : .init(hex: "#D1D1D1") }
  }
  
  private var subscriptions: Set<AnyCancellable> = .init()

  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  
  @available(*, unavailable) required init?(coder: NSCoder) { fatalError("Not implemented") }
  
  private func configureUI() {
    backgroundColor     = .black
    clipsToBounds       = true
    layer.cornerRadius  = 4
		setTitleColor(PND.Colors.commonWhite, for: .normal)
    titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
  }
  
  func configure(viewModel: BaseBottomButtonViewModel) {
    setTitle(viewModel.buttonTitle, for: .normal)
    setTitleColor(PND.Colors.commonWhite, for: .normal)
    titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    
    self.snp.remakeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(Self.defaultHeight)
    }
    
    viewModel.$isEnabled
      .receiveOnMainQueue()
      .assignNoRetain(to: \.isEnabled, on: self)
      .store(in: &subscriptions)
  }
}
