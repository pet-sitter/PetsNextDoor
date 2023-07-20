//
//  BaseTextFieldView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/20.
//

import UIKit
import SnapKit
import Combine

class BaseTextFieldView: UIView {
  
  static let defaultHeight: CGFloat = 54
  
  private var containerView: UIView!
  private var textField: UITextField!
  private var focusLineView: UIView!
  
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
  
  convenience init(textFieldPlaceHolder: String) {
    self.init()
    textField.placeholder = textFieldPlaceHolder
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
//      $0.backgroundColor = .systemTeal
      $0.tintColor = PND.Colors.commonBlack
      $0.snp.makeConstraints {
        $0.top.equalToSuperview().inset(5)
        $0.leading.trailing.equalToSuperview().inset(5)
        $0.bottom.equalToSuperview().inset(5)
      }
    }
    
    focusLineView = UIView()
    focusLineView.set {
      containerView.addSubview($0)
      $0.backgroundColor = UIColor(hex: "#D9D9D9")
      $0.snp.makeConstraints {
        $0.height.equalTo(1)
        $0.leading.trailing.bottom.equalToSuperview()
      }
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
}
