//
//  UIView+Extension.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/08/22.
//

import UIKit

extension UIView {
	
  @discardableResult
	func onViewTap(_ action : @escaping () -> Void) -> Self {
		let tap = PNDTapGestureRecognizer(target: self , action: #selector(self.handleTap(_:)))
		tap.action = action
		tap.numberOfTapsRequired = 1
		self.addGestureRecognizer(tap)
		self.isUserInteractionEnabled = true
    return self
	}
	
	@objc func handleTap(_ sender: PNDTapGestureRecognizer) {
		sender.action!()
	}
}

class PNDTapGestureRecognizer: UITapGestureRecognizer {
	var action : (() -> Void)? = nil
}



extension UIView {
  
  @discardableResult
  func roundCorners(radius: CGFloat) -> Self {
    roundCorners(radius: radius, corners: [.allCorners])
    
    return self
  }
  
  @discardableResult
  func roundCorners(radius: CGFloat, corners: UIRectCorner) -> Self {
    print(self.bounds)
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    layer.mask = maskLayer
    
    return self
  }
  
  @discardableResult
  func makeCircle() -> Self {
    roundCorners(radius: frame.width / 2)
    return self
  }
  
  @discardableResult
  func makeCircleAndBorder(color: UIColor, width: CGFloat) -> Self {
    clipsToBounds = true
    layer.cornerRadius = bounds.width / 2
    layer.borderWidth = width
    layer.borderColor = color.cgColor
    return self
  }
  
  @discardableResult
  func makeLayerCircle() -> Self {
    clipsToBounds = true
    layer.cornerRadius = bounds.width / 2
    return self
  }
  
  @discardableResult
  func makeLayerCorner(radius: CGFloat) -> Self {
    clipsToBounds = true
    layer.cornerRadius = radius
    return self
  }
  
  @discardableResult
  func makeLayerCornerAndBorder(radius: CGFloat, color: UIColor, width: CGFloat) -> Self {
    clipsToBounds = true
    layer.cornerRadius = radius
    layer.borderWidth = width
    layer.borderColor = color.cgColor
    return self
  }
  
  static var statusBarHeight: CGFloat {
    UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.top ?? UIApplication.shared.statusBarFrame.height
  }

  static var topSafeAreaHeight: CGFloat {

    if #available(iOS 11.0, *),
       let window = UIApplication.shared.keyWindow ?? UIApplication.shared.delegate?.window {
      return window?.safeAreaInsets.top ?? 0
    }

    return 0
  }

  static var leadingSafeAreaWidth: CGFloat {

    if #available(iOS 11.0, *),
       let window = UIApplication.shared.keyWindow ?? UIApplication.shared.delegate?.window {
      return window?.safeAreaInsets.left ?? 0
    }
    
    return 0
  }

  static var trailingSafeAreaWidth: CGFloat {

    if #available(iOS 11.0, *),
       let window = UIApplication.shared.keyWindow ?? UIApplication.shared.delegate?.window {
      return window?.safeAreaInsets.right ?? 0
    }
    
    return 0
  }

  static var bottomSafeAreaHeight: CGFloat {
    
    if #available(iOS 11.0, *),
       let window = UIApplication.shared.keyWindow ?? UIApplication.shared.delegate?.window {
      return window?.safeAreaInsets.bottom ?? 0
    }
    
    return 0
  }
  
  static var safeAreaBottom: CGFloat {
    UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.bottom ?? 0
  }

  static var systemNavigationHeight: CGFloat {

    if #available(iOS 12.0, *), UIDevice.current.userInterfaceIdiom == .pad {
      return 50.0
    }
    return UIDevice.current.orientation.isLandscape ? 32 : 44
  }
  
  @discardableResult
  func round(topLeft: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0, topRight: CGFloat = 0, size: CGSize) -> Self {
    let path = UIBezierPath()
    path.addArc(withCenter: CGPoint(x: topLeft, y: topLeft), radius: topLeft, startAngle: 3 * .pi / 2, endAngle: .pi, clockwise: false)
    path.addLine(to: CGPoint(x: 0, y: size.height - bottomLeft))
    path.addArc(withCenter: CGPoint(x: bottomLeft, y: size.height - bottomLeft), radius: bottomLeft, startAngle: .pi, endAngle: .pi / 2, clockwise: false)
    path.addLine(to: CGPoint(x: size.width - bottomRight, y: size.height))
    path.addArc(withCenter: CGPoint(x: size.width - bottomRight, y: size.height - bottomRight), radius: bottomRight, startAngle: .pi / 2, endAngle: 0, clockwise: false)
    path.addLine(to: CGPoint(x: size.width, y: topRight))
    path.addArc(withCenter: CGPoint(x: size.width - topRight, y: topRight), radius: topRight, startAngle: 0, endAngle: 3 * .pi / 2, clockwise: false)
    path.addLine(to: CGPoint(x: topLeft, y: 0))

    let maskingLayer = CAShapeLayer()
    maskingLayer.path = path.cgPath
    self.layer.mask = maskingLayer

    return self
  }

  @discardableResult
  func bgColor(_ color: UIColor?) -> Self {
    self.backgroundColor = color
    return self
  }

  @discardableResult
  func size(width: CGFloat, height: CGFloat) -> Self {
    self.snp.makeConstraints { maker in
      maker.width.equalTo(width).priority(.high)
      maker.height.equalTo(height).priority(.high)
    }
    return self
  }

  @discardableResult
  func height(_ height: CGFloat) -> Self {
    self.snp.makeConstraints { maker in
      maker.height.equalTo(height).priority(.high)
    }
    return self
  }

  @discardableResult
  func width(_ width: CGFloat) -> Self {
    self.snp.makeConstraints { maker in
      maker.width.equalTo(width).priority(.high)
    }
    return self
  }

  @discardableResult
  func contentFill() -> Self {
    self.contentMode = .scaleToFill
    return self
  }

  @discardableResult
  func contentAspectFit() -> Self {
    self.contentMode = .scaleAspectFit
    return self
  }

  @discardableResult
  func contentAspectFill() -> Self {
    self.contentMode = .scaleAspectFill
    return self
  }

  @discardableResult
  func contentRedraw() -> Self {
    self.contentMode = .redraw
    return self
  }

  @discardableResult
  func contentCenter() -> Self {
    self.contentMode = .center
    return self
  }

  @discardableResult
  func contentTop() -> Self {
    self.contentMode = .top
    return self
  }

  @discardableResult
  func contentBottom() -> Self {
    self.contentMode = .bottom
    return self
  }

  @discardableResult
  func contentLeft() -> Self {
    self.contentMode = .left
    return self
  }

  @discardableResult
  func contentRight() -> Self {
    self.contentMode = .right
    return self
  }

  @discardableResult
  func contentTopLeft() -> Self {
    self.contentMode = .topLeft
    return self
  }

  @discardableResult
  func contentTopRight() -> Self {
    self.contentMode = .topRight
    return self
  }

  @discardableResult
  func contentBottomLeft() -> Self {
    self.contentMode = .bottomLeft
    return self
  }

  @discardableResult
  func contentBottomRight() -> Self {
    self.contentMode = .bottomRight
    return self
  }

  @discardableResult
  func clipsToBounds(_ mode: Bool = true) -> Self {
    self.clipsToBounds = mode
    return self
  }

  @discardableResult
  func lowContentHuggingPriority(_ axis: NSLayoutConstraint.Axis) -> Self {
    self.setContentHuggingPriority(UILayoutPriority.defaultLow, for: axis)
    return self
  }

  @discardableResult
  func highContentHuggingPriority(_ axis: NSLayoutConstraint.Axis) -> Self {
    self.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: axis)
    return self
  }

  @discardableResult
  func requiredContentHuggingPriority(_ axis: NSLayoutConstraint.Axis) -> Self {
    self.setContentHuggingPriority(UILayoutPriority.required, for: axis)
    return self
  }

  @discardableResult
  func lowContentResistancePriority(_ axis: NSLayoutConstraint.Axis) -> Self {
    self.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: axis)
    return self
  }

  @discardableResult
  func highContentResistancePriority(_ axis: NSLayoutConstraint.Axis) -> Self {
    self.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: axis)
    return self
  }

  @discardableResult
  func requiredContentResistancePriority(_ axis: NSLayoutConstraint.Axis) -> Self {
    self.setContentCompressionResistancePriority(UILayoutPriority.required, for: axis)
    return self
  }

  @discardableResult
  func enableUserInteraction() -> Self {
    self.isUserInteractionEnabled = true
    return self
  }

  @discardableResult
  func disableUserInteraction() -> Self {
    self.isUserInteractionEnabled = false
    return self
  }

  @discardableResult
  func horizontalCompressionResistance(priority: UILayoutPriority) -> Self {
    self.setContentCompressionResistancePriority(priority, for: .horizontal)
    return self
  }

  @discardableResult
  func verticalCompressionResistance(priority: UILayoutPriority) -> Self {
    self.setContentCompressionResistancePriority(priority, for: .vertical)
    return self
  }

  @discardableResult
  func horizontalHugging(priority: UILayoutPriority) -> Self {
    self.setContentHuggingPriority(priority, for: .horizontal)
    return self
  }

  @discardableResult
  func verticalHugging(priority: UILayoutPriority) -> Self {
    self.setContentHuggingPriority(priority, for: .vertical)
    return self
  }

  @discardableResult
  func hidden(_ isHidden: Bool = true) -> Self {
    self.isHidden = isHidden
    return self
  }

  @discardableResult
  func show() -> Self {
    self.isHidden = false
    return self
  }

  @discardableResult
  func border(color: UIColor, thin: CGFloat = 0.5) -> Self {
    self.layer.borderColor = color.cgColor
    self.layer.borderWidth = thin
    return self
  }

  @discardableResult
  func borderWidth(_ thin: CGFloat) -> Self {
    self.layer.borderWidth = thin
    return self
  }

  @discardableResult
  func frame(_ frame: CGRect) -> Self {
    self.frame = frame
    return self
  }
  
  @discardableResult
  func frame(width: CGFloat, height: CGFloat) -> Self {
    self.frame = .init(x: 0, y: 0, width: width, height: height)
    return self
  }

  @discardableResult
  func frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> Self {
    self.frame = CGRect(x: x, y: y, width: width, height: height)
    return self
  }

  @discardableResult
  func frame(origin: CGPoint, size: CGSize) -> Self {
    self.frame = CGRect(origin: origin, size: size)
    return self
  }

  @discardableResult
  func tintColor(_ color: UIColor) -> Self {
    self.tintColor = color
    return self
  }

  @discardableResult
  func alpha(_ alpha: CGFloat) -> Self {
    self.alpha = alpha
    return self
  }

  @discardableResult
  func shadow(_ color: UIColor, offset: CGSize = CGSize(width: 0, height: 0), radius: CGFloat = 5, opacity: Float = 0.5) -> Self {
    self.layer.shadowColor = color.cgColor
    self.layer.masksToBounds = false
    self.layer.shadowOffset = offset
    self.layer.shadowRadius = radius
    self.layer.shadowOpacity = opacity
    return self
  }

  @discardableResult
  func applyMask(_ imageName: String) -> Self {

    guard let maskImage = UIImage(named: imageName) else {
      return self
    }

    let maskLayer = CALayer()
    maskLayer.frame = CGRect(origin: .zero, size: maskImage.size)
    maskLayer.contents = maskImage.cgImage
    self.layer.mask = maskLayer
    return self
  }

}


