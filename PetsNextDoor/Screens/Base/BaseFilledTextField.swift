//
//  BaseFilledTextFieldView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/08.
//

import UIKit
import Combine
import SnapKit

final class BaseFilledTextFieldViewModel: HashableViewModel {
  let textFieldPlaceHolder: String
  let maxCharactersLimit: Int
  let backgroundColor: UIColor
  let font: UIFont
  let keyboardType: UIKeyboardType
  
  init(
    textFieldPlaceHolder: String,
    maxCharactersLimit: Int,
    backgroundColor: UIColor = UIColor(hex: "#F3F3F3"),
    font: UIFont = .systemFont(ofSize: 20, weight: .regular),
    keyboardType: UIKeyboardType = .default
  ) {
    self.textFieldPlaceHolder = textFieldPlaceHolder
    self.maxCharactersLimit   = maxCharactersLimit
    self.backgroundColor      = backgroundColor
    self.font                 = font
    self.keyboardType         = keyboardType
  }
}

class BaseFilledTextField: UIView, HeightProvidable {
  
  static var defaultHeight: CGFloat { 40.0 }
  
  private var containerView: UIView!
  private var textField: UITextField!
  
  var onTextChange: ((String?) -> Void)?
  
  private var subscriptions = Set<AnyCancellable>()
  
  private var viewModel: BaseFilledTextFieldViewModel?
  
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
      $0.layer.cornerRadius = 4
      $0.rightViewMode = .always
      $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
      $0.textAlignment = .right
      $0.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
    
  }
  
  @discardableResult
  func configure(viewModel: BaseFilledTextFieldViewModel) -> Self {
    
    self.viewModel = viewModel
    
    textField.keyboardType    = viewModel.keyboardType
    textField.placeholder     = viewModel.textFieldPlaceHolder
    textField.font            = viewModel.font
    textField.backgroundColor = viewModel.backgroundColor
    
    textField.controlEventPublisher(for: .editingChanged)
      .withStrong(self)
      .sink { strongSelf, _ in
        strongSelf.onTextChange?(strongSelf.textField.text)
      }
      .store(in: &subscriptions)
    
    return self
  }
}

extension BaseFilledTextField: UITextFieldDelegate {
  
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    guard let maxCharacterLimit = viewModel?.maxCharactersLimit else { return true }
    let currentText = (textField.text ?? "") + string
    
    if currentText.count > maxCharacterLimit {
      return false
    } else {
      return true
    }
  }
}
