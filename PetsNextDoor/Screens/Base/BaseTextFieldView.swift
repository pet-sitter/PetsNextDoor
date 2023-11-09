//
//  BaseTextFieldView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/30.
//

import UIKit
import SnapKit
import Combine

final class BaseTextFieldViewModel: HashableViewModel {
  let textFieldPlaceHolder: String
  var maxCharactersLimit: Int? = nil
  var rightView: UIView? = nil
  
  init(textFieldPlaceHolder: String, maxCharactersLimit: Int? = nil, rightView: UIView? = nil) {
    self.textFieldPlaceHolder = textFieldPlaceHolder
    self.maxCharactersLimit = maxCharactersLimit
    self.rightView = rightView
  }
}

class BaseTextFieldView: UIView, HeightProvidable {
  
  static var defaultHeight: CGFloat = 54
  
  var containerView: UIView!
  var textField: UITextField!
  var focusLineView: UIView!
  
  var rightView: UIView?
  
  private var maxCharacterLimit: Int?
  
  var isTextFieldFirstResponder: Bool {
    didSet {
      UIView.animate(withDuration: 0.25) {
        self.focusLineView.backgroundColor = self.isTextFieldFirstResponder
        ? PND.Colors.commonBlack
        : UIColor(hex: "#D9D9D9")
      }
    }
  }
  
  private var subscriptions = Set<AnyCancellable>()
  
  init() {
    isTextFieldFirstResponder = false
    super.init(frame: .zero)
    configureUI()
    observeControlEvents()
  }
  
  @available(*, unavailable) required init?(coder: NSCoder) { fatalError("Not implemented") }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    textField.snp.makeConstraints {
      $0.top.equalToSuperview().inset(5)
      $0.leading.trailing.equalToSuperview().inset(PND.Metrics.defaultSpacing)
      $0.bottom.equalToSuperview().inset(5)
    }
    
    focusLineView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(PND.Metrics.defaultSpacing)
    }
  }

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
    }
    
    focusLineView = UIView()
    focusLineView.set {
      containerView.addSubview($0)
      $0.backgroundColor = UIColor(hex: "#D9D9D9")
    }
  }
  
  private func observeControlEvents() {
    
    textField.controlEventPublisher(for: .editingDidBegin)
      .map { _ in true }
      .assignNoRetain(to: \.isTextFieldFirstResponder, on: self)
      .store(in: &subscriptions)
    
    textField.controlEventPublisher(for: .editingDidEnd)
      .map { _ in false }
      .assignNoRetain(to: \.isTextFieldFirstResponder, on: self)
      .store(in: &subscriptions)
  }
  
  func configure(viewModel: BaseTextFieldViewModel) {
    
    textField.placeholder = viewModel.textFieldPlaceHolder
    maxCharacterLimit     = viewModel.maxCharactersLimit
    
    if let rightView = viewModel.rightView {
      
      containerView.addSubview(rightView)
      rightView.snp.makeConstraints {
        $0.trailing.equalToSuperview().inset(20)
        $0.centerY.equalToSuperview()
        $0.height.equalTo(rightView.frame.height)
        $0.width.greaterThanOrEqualTo(rightView.frame.size)
      }
      
      textField.snp.updateConstraints {
        $0.trailing.equalToSuperview().inset(rightView.frame.width + 20 + 5)
      }
    }
  }
}

extension BaseTextFieldView: UITextFieldDelegate {
  
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

