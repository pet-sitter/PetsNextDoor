//
//  BaseCheckBoxView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/10.
//

import UIKit
import Combine
import SnapKit


final class BaseCheckBoxViewModel: HashableViewModel {
  
  @Published var isChecked: Bool
  
  init(isChecked: Bool) {
    self.isChecked = isChecked
  }
}

class BaseCheckBoxButton: UIView, HeightProvidable {
  
  static var defaultHeight: CGFloat { 24.0 }
  
  private var containerView: UIView!
  private var checkBoxButton: UIButton!
  
  var onCheckBoxTap: ((Bool) -> Void)?
  
  private var subscriptions = Set<AnyCancellable>()
  
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  @available(*, unavailable) required init?(coder: NSCoder) { fatalError("Not implemented") }
  
  private func configureUI() {
    
    containerView = UIView()
    containerView.set {
      addSubview($0)
      $0.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    checkBoxButton = UIButton(type: .custom)
    checkBoxButton.set {
      containerView.addSubview($0)
      $0.setImage(
        .init(systemName: "checkmark.square")?
          .withTintColor(PND.Colors.commonGrey, renderingMode: .alwaysOriginal),
        for: .normal
      )
      
      $0.setImage(
        .init(systemName: "checkmark.square.fill")?
          .withTintColor(PND.Colors.commonOrange, renderingMode: .alwaysOriginal),
        for: .selected
      )
      $0.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
  }
  
  @discardableResult
  func configure(viewModel: BaseCheckBoxViewModel) -> Self {
    
    viewModel.$isChecked
      .receiveOnMainQueue()
      .sink { [weak self] isChecked in
        self?.checkBoxButton.isSelected = isChecked
      }
      .store(in: &subscriptions)
    
    checkBoxButton.tapPublisher
      .withStrong(self)
      .sink { strongSelf, _ in
        strongSelf.checkBoxButton.isSelected.toggle()
        strongSelf.onCheckBoxTap?(strongSelf.checkBoxButton.isSelected)
      }
      .store(in: &subscriptions)
    
    return self
  }
}

