//
//  BaseEmptyTextFieldView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/14.
//

import UIKit
import SnapKit
import Combine

final class BaseEmptyTextFieldViewModel: HashableViewModel {
  
  let textFieldPlaceHolder: String
  let maxCharactersLimit: Int?
  let font: UIFont
  
  init(
    textFieldPlaceHolder: String,
    maxCharactersLimit: Int? = nil,
    font: UIFont = .systemFont(ofSize: 24, weight: .regular)
  ) {
    self.textFieldPlaceHolder = textFieldPlaceHolder
    self.maxCharactersLimit = maxCharactersLimit
    self.font = font
  }
}

class BaseEmptyTextFieldView: UIView, HeightProvidable {
  
  static var defaultHeight: CGFloat { 30.0 }
  
  private var containerView: UIView!
  private var textField: UITextField!
  
  private var maxCharacterLimit: Int?
  
  var onTextChange: ((String?) -> Void)?

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
    
    textField = UITextField()
    textField.set {
      containerView.addSubview($0)
      $0.delegate = self
      $0.tintColor = PND.Colors.commonBlack
      $0.textAlignment = .left
      $0.backgroundColor = .clear
      $0.snp.makeConstraints {
        $0.top.bottom.equalToSuperview()
        $0.leading.trailing.equalToSuperview().inset(PND.Metrics.defaultSpacing)
      }
    }
  }
  
  @discardableResult
  func configure(viewModel: BaseEmptyTextFieldViewModel) -> Self {
    
    textField.placeholder = viewModel.textFieldPlaceHolder
    maxCharacterLimit     = viewModel.maxCharactersLimit
    textField.font        = viewModel.font
    
    textField.controlEventPublisher(for: .editingChanged)
      .withStrong(self)
      .sink { strongSelf, _ in
        strongSelf.onTextChange?(strongSelf.textField.text)
      }
      .store(in: &subscriptions)
    
    return self
  }
}

extension BaseEmptyTextFieldView: UITextFieldDelegate {
  
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    guard let maxCharacterLimit else { return true }
    let currentText = (textField.text ?? "") + string
    
    if currentText.count > maxCharacterLimit {
      return false
    } else {
      return true
    }
  }
}
