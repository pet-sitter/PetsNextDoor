//
//  String+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/02.
//

import UIKit

extension String {
  func calculateEstimateCGRect(
    fontSize: CGFloat,
    size: CGSize,
    weight: UIFont.Weight,
    numberOfLines: Int = 0,
    lineBreakMode: NSLineBreakMode = .byWordWrapping,
    lineHeightMultiple: CGFloat = 0,
    lineHeight: CGFloat? = nil
  ) -> CGRect {
    
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    label.numberOfLines = numberOfLines
    let paragraphStyle = NSMutableParagraphStyle()
    if let height = lineHeight {
      paragraphStyle.maximumLineHeight = height
      paragraphStyle.minimumLineHeight = height
    }
    paragraphStyle.lineHeightMultiple = lineHeightMultiple
    paragraphStyle.lineBreakMode = lineBreakMode
    let attrStr = NSAttributedString(string: self, attributes: [.font: UIFont.systemFont(ofSize: fontSize, weight: weight), .paragraphStyle: paragraphStyle])
    label.attributedText = attrStr
    label.sizeToFit()
    return label.frame
  }
  
  static var commonError: String {
    "네트워크 연결 상태를 확인해주세요."
  }
  
  func asURL() -> URL? {
    URL(string: self)
  }
}
