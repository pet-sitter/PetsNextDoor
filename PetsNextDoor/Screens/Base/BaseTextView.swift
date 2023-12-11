//
//  BaseTextView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/14.
//

import UIKit
import SnapKit
import Combine

final class BaseTextViewModel: HashableViewModel {
  let placeHolder: String
  let font: UIFont
  
  init(placeHolder: String, font: UIFont = .systemFont(ofSize: 16, weight: .regular)) {
    self.placeHolder = placeHolder
    self.font = font
  }
}

class BaseTextView: UIView, HeightProvidable {
  
  static var defaultHeight: CGFloat { CGFloat.greatestFiniteMagnitude }
  
  private var containerView: UIView!
  private var textView: UITextView!
  
  private var placeHolder: String = ""
  private let defaultPlaceHolderColor = UIColor(hex: "8F8F8F")
  
  var onTextChange: ((String) -> Void)?
  
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  @available(*, unavailable) required init?(coder: NSCoder) { fatalError("Not implemented") }
  
  private func configureUI() {
    
    containerView = UIView()
    textView      = UITextView()
    
    containerView.set {
      addSubview($0)
      $0.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    textView.set {
      containerView.addSubview($0)
      $0.isScrollEnabled = true
      $0.isEditable = true
      $0.textColor = PND.Colors.commonBlack
      $0.delegate = self
      $0.textColor = defaultPlaceHolderColor
      $0.textContainerInset = .init(top: 0, left: 0, bottom: 0, right: 0)
      $0.textContainer.lineFragmentPadding = 0
      $0.snp.makeConstraints {
        $0.top.bottom.equalToSuperview()
        $0.leading.trailing.equalToSuperview().inset(PND.Metrics.defaultSpacing)
      }
    }
  }
  
  func configure(viewModel: BaseTextViewModel) {
    
    self.placeHolder    = viewModel.placeHolder
    textView.textColor  = defaultPlaceHolderColor
    textView.text       = viewModel.placeHolder
  }
}

//MARK: - UITextViewDelegate
 
extension BaseTextView: UITextViewDelegate {
  
  func textViewDidEndEditing(_ textView: UITextView) {

    if textView.text.isEmpty {
      textView.text = placeHolder
      textView.textColor = defaultPlaceHolderColor
    }
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {

    if textView.textColor == defaultPlaceHolderColor {
      textView.text = nil
      textView.textColor = PND.Colors.commonBlack
    }

  }
  
  func textViewDidChange(_ textView: UITextView) {
    onTextChange?(textView.text)
  }
}
