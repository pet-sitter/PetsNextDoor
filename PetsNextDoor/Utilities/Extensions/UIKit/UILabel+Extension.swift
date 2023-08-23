//
//  UILabel+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/23.
//

import UIKit

extension UILabel {

  @discardableResult
  func lineNumber(_ num: Int) -> Self {
    self.numberOfLines = num
    return self
  }

  @discardableResult
  func text(_ text: String?, font: UIFont? = nil, color: UIColor? = nil) -> Self {
    if font != nil {
      self.font = font!
    }

    if color != nil {
      self.textColor = color!
    }

    let paragraphStyle  = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.08
    paragraphStyle.lineBreakMode = self.lineBreakMode
    paragraphStyle.alignment = self.textAlignment

    let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font ?? self.font!,
                             NSAttributedString.Key.paragraphStyle: paragraphStyle,
                             NSAttributedString.Key.foregroundColor: color ?? self.textColor!]

    let attrString = NSAttributedString(string: text ?? "", attributes: attributes)
    self.attributedText = attrString

    return self
  }
  
  @discardableResult
  func color(_ color: UIColor) -> Self {
    self.textColor = color
    return self
  }
  
  @discardableResult
  func font(_ font: UIFont) -> Self {
    self.font = font
    return self 
  }
  
  

  @discardableResult
  func attributedText(_ attributedText: NSAttributedString?, hidesWhenNil: Bool = false) -> Self {
    self.attributedText = attributedText

    if hidesWhenNil {
      self.isHidden = attributedText == nil
    }

    return self
  }

  @discardableResult
  func textStyle(font: UIFont, color: UIColor, alignment: NSTextAlignment = .left) -> Self {
    self.font = font
    self.textColor = color
    self.textAlignment = alignment
    return self
  }

  @discardableResult
  func lineBreakWordWrap() -> Self {
    self.lineBreakMode = .byWordWrapping
    return self
  }

  @discardableResult
  func lineBreakTail() -> Self {
    self.lineBreakMode = .byTruncatingTail
    return self
  }

  @discardableResult
  func lineBreak(if condition: Bool, then trueMode: NSLineBreakMode, else falseMode: NSLineBreakMode) -> Self {
    if condition == true {
      self.lineBreakMode = trueMode
    } else {
      self.lineBreakMode = falseMode
    }

    return self
  }

  @discardableResult
  func centerAlignment() -> Self {
    self.textAlignment = .center
    return self
  }

  @discardableResult
  func leftAlignment() -> Self {
    self.textAlignment = .left
    return self
  }

  @discardableResult
  func rightAlignment() -> Self {
    self.textAlignment = .right
    return self
  }
  
}
