//
//  UIButton+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/23.
//

import UIKit
import Combine

extension UIButton {

  @discardableResult
  func title(_ text: String?) -> Self {
    self.setTitle(text, for: .normal)
    self.setTitle(text, for: .selected)
    self.setTitle(text, for: .highlighted)
    self.setTitle(text, for: .disabled)
    return self
  }

  @discardableResult
  func normalTitle(_ text: String?) -> Self {
    self.setTitle(text, for: .normal)
    return self
  }

  @discardableResult
  func selectedTitle(_ text: String?) -> Self {
    self.setTitle(text, for: .selected)
    return self
  }

  @discardableResult
  func highlightedTitle(_ text: String?) -> Self {
    self.setTitle(text, for: .highlighted)
    return self
  }

  @discardableResult
  func disabledTitle(_ text: String?) -> Self {
    self.setTitle(text, for: .disabled)
    return self
  }

  @discardableResult
  func userInteractedTitle(_ text: String?) -> Self {
    self.setTitle(text, for: .selected)
    self.setTitle(text, for: .highlighted)
    return self
  }

  @discardableResult
  func titleStyle(font: UIFont? = nil, color: UIColor? = nil) -> Self {
    if font != nil {
      self.titleLabel?.font = font
    }

    if color != nil {
      self.setTitleColor(color!, for: .normal)
      self.setTitleColor(color!, for: .selected)
      self.setTitleColor(color!, for: .highlighted)
      self.setTitleColor(color!, for: .disabled)
    }

    return self
  }

  @discardableResult
  func normalTitleStyle(font: UIFont? = nil, color: UIColor? = nil) -> Self {
    if font != nil {
      self.titleLabel?.font = font
    }

    if color != nil {
      self.setTitleColor(color!, for: .normal)
    }

    return self
  }

  @discardableResult
  func selectedTitleStyle(font: UIFont? = nil, color: UIColor? = nil) -> Self {
    if font != nil {
      self.titleLabel?.font = font
    }

    if color != nil {
      self.setTitleColor(color!, for: .selected)
    }

    return self
  }

  @discardableResult
  func highlightedTitleStyle(font: UIFont? = nil, color: UIColor? = nil) -> Self {
    if font != nil {
      self.titleLabel?.font = font
    }

    if color != nil {
      self.setTitleColor(color!, for: .highlighted)
    }

    return self
  }

  @discardableResult
  func disabledTitleStyle(font: UIFont? = nil, color: UIColor? = nil) -> Self {
    if font != nil {
      self.titleLabel?.font = font
    }

    if color != nil {
      self.setTitleColor(color!, for: .disabled)
    }

    return self
  }

  @discardableResult
  func userInteractedTitleStyle(font: UIFont? = nil, color: UIColor? = nil) -> Self {
    if font != nil {
      self.titleLabel?.font = font
    }

    if color != nil {
      self.setTitleColor(color!, for: .selected)
      self.setTitleColor(color!, for: .highlighted)
    }

    return self
  }

  @discardableResult
  func normalTitle(_ title: String?, font: UIFont? = nil, color: UIColor? = nil) -> Self {
    return self.normalTitle(title).normalTitleStyle(font: font, color: color)
  }

  @discardableResult
  func selectedTitle(_ title: String?, font: UIFont? = nil, color: UIColor? = nil) -> Self {
    return self.selectedTitle(title).selectedTitleStyle(font: font, color: color)
  }

  @discardableResult
  func highlightedTitle(_ title: String?, font: UIFont? = nil, color: UIColor? = nil) -> Self {
    return self.highlightedTitle(title).highlightedTitleStyle(font: font, color: color)
  }

  @discardableResult
  func disabledTitle(_ title: String?, font: UIFont? = nil, color: UIColor? = nil) -> Self {
    return self.disabledTitle(title).disabledTitleStyle(font: font, color: color)
  }

  @discardableResult
  func userInteractedTitle(_ title: String?, font: UIFont? = nil, color: UIColor? = nil) -> Self {
    return self.userInteractedTitle(title).userInteractedTitleStyle(font: font, color: color)
  }

  @discardableResult
  func image(_ image: UIImage?) -> Self {
    self.setImage(image, for: .normal)
    self.setImage(image, for: .selected)
    self.setImage(image, for: .highlighted)
    self.setImage(image, for: .disabled)
    return self
  }

  @discardableResult
  func normalImage(_ image: UIImage?) -> Self {
    self.setImage(image, for: .normal)
    return self
  }

  @discardableResult
  func selectedImage(_ image: UIImage?) -> Self {
    self.setImage(image, for: .selected)
    return self
  }

  @discardableResult
  func highlightedImage(_ image: UIImage?) -> Self {
    self.setImage(image, for: .highlighted)
    return self
  }

  @discardableResult
  func disabledImage(_ image: UIImage?) -> Self {
    self.setImage(image, for: .disabled)
    return self
  }

  @discardableResult
  func userInteractedImage(_ image: UIImage?) -> Self {
    self.setImage(image, for: .selected)
    self.setImage(image, for: .highlighted)
    return self
  }

  @discardableResult
  func image(named name: String) -> Self {
    self.setImage(UIImage(named: name), for: .normal)
    self.setImage(UIImage(named: name), for: .selected)
    self.setImage(UIImage(named: name), for: .highlighted)
    self.setImage(UIImage(named: name), for: .disabled)
    return self
  }

  @discardableResult
  func normalImage(named name: String) -> Self {
    self.setImage(UIImage(named: name), for: .normal)
    return self
  }

  @discardableResult
  func selectedImage(named name: String) -> Self {
    self.setImage(UIImage(named: name), for: .selected)
    return self
  }

  @discardableResult
  func highlightedImage(named name: String) -> Self {
    self.setImage(UIImage(named: name), for: .highlighted)
    return self
  }

  @discardableResult
  func disabledImage(named name: String) -> Self {
    self.setImage(UIImage(named: name), for: .disabled)
    return self
  }

  @discardableResult
  func userInteractedImage(named name: String) -> Self {
    self.setImage(UIImage(named: name), for: .selected)
    self.setImage(UIImage(named: name), for: .highlighted)
    return self
  }

  @discardableResult
  func invertingImagePosition() -> Self {
    let transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    self.transform = transform
    self.titleLabel?.transform = transform
    self.imageView?.transform = transform
    return self
  }

  @discardableResult
  func contentInsets(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Self {
    self.contentEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    return self
  }

  @discardableResult
  func contentInsets(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> Self {
    self.contentEdgeInsets = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    return self
  }

  @discardableResult
  func contentEdgeInsets(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> Self {
    var newInsets = self.contentEdgeInsets

    if let newTop = top {
      newInsets.top = newTop
    }

    if let newLeft = left {
      newInsets.left = newLeft
    }

    if let newBottom = bottom {
      newInsets.bottom = newBottom
    }

    if let newRight = right {
      newInsets.right = newRight
    }

    self.contentEdgeInsets = newInsets
    return self
  }

  @discardableResult
  func imageEdgeInsets(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> Self {
    var newInsets = self.imageEdgeInsets

    if let newTop = top {
      newInsets.top = newTop
    }

    if let newLeft = left {
      newInsets.left = newLeft
    }

    if let newBottom = bottom {
      newInsets.bottom = newBottom
    }

    if let newRight = right {
      newInsets.right = newRight
    }

    self.imageEdgeInsets = newInsets
    return self
  }

  @discardableResult
  func titleEdgeInsets(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> Self {
    var newInsets = self.titleEdgeInsets

    if let newTop = top {
      newInsets.top = newTop
    }

    if let newLeft = left {
      newInsets.left = newLeft
    }

    if let newBottom = bottom {
      newInsets.bottom = newBottom
    }

    if let newRight = right {
      newInsets.right = newRight
    }

    self.titleEdgeInsets = newInsets
    return self
  }

  @discardableResult
  func selected(_ selected: Bool = true) -> Self {
    self.isSelected = selected
    return self
  }

  @discardableResult
  func isEnabled(_ enabled: Bool = true) -> Self {
    self.isEnabled = enabled
    return self
  }


}

