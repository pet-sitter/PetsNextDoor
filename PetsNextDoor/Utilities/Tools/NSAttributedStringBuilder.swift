//
//  NSAttributedStringBuilder.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/10.
//

import UIKit



import UIKit
//public typealias Font = UIFont
//public typealias Color = UIColor


public typealias Attributes = [NSAttributedString.Key: Any]

@resultBuilder
public enum NSAttributedStringBuilder {
  public static func buildBlock(_ AttributeComponents: AttributeComponent...) -> NSAttributedString {
    let mas = NSMutableAttributedString(string: "")
    for AttributeComponent in AttributeComponents {
      mas.append(AttributeComponent.attributedString)
    }
    return mas
  }
}

public extension NSAttributedString {
  convenience init(@NSAttributedStringBuilder _ builder: () -> NSAttributedString) {
    self.init(attributedString: builder())
  }
}


#if canImport(UIKit)
import UIKit
public typealias Size = CGSize
#elseif canImport(AppKit)
import AppKit
public typealias Size = NSSize
#endif

public protocol AttributeComponent {
  var string: String { get }
  var attributes: Attributes { get }
  var attributedString: NSAttributedString { get }
}

public enum Ligature: Int {
  case none = 0
  case `default` = 1
  
#if canImport(AppKit)
  case all = 2 // Value 2 is unsupported on iOS
#endif
}

public extension AttributeComponent {
  private func build(_ string: String, attributes: Attributes) -> AttributeComponent {
    AText(string, attributes: attributes)
  }
  
  var attributedString: NSAttributedString {
    NSAttributedString(string: string, attributes: attributes)
  }
  
  func attribute(_ newAttribute: NSAttributedString.Key, value: Any) -> AttributeComponent {
    attributes([newAttribute: value])
  }
  
  func attributes(_ newAttributes: Attributes) -> AttributeComponent {
    var attributes = self.attributes
    for attribute in newAttributes {
      attributes[attribute.key] = attribute.value
    }
    return build(string, attributes: attributes)
  }
}

// MARK: Basic Modifiers

public extension AttributeComponent {
  func backgroundColor(_ color: UIColor) -> AttributeComponent {
    attributes([.backgroundColor: color])
  }
  
  func baselineOffset(_ baselineOffset: CGFloat) -> AttributeComponent {
    attributes([.baselineOffset: baselineOffset])
  }
  
  func font(_ font: UIFont) -> AttributeComponent {
    attributes([.font: font])
  }
  
  func foregroundColor(_ color: UIColor) -> AttributeComponent {
    attributes([.foregroundColor: color])
  }
  
  func expansion(_ expansion: CGFloat) -> AttributeComponent {
    attributes([.expansion: expansion])
  }
  
  func kerning(_ kern: CGFloat) -> AttributeComponent {
    attributes([.kern: kern])
  }
  
  func ligature(_ ligature: Ligature) -> AttributeComponent {
    attributes([.ligature: ligature.rawValue])
  }
  
  func obliqueness(_ obliqueness: Float) -> AttributeComponent {
    attributes([.obliqueness: obliqueness])
  }
  
  func shadow(color: UIColor? = nil, radius: CGFloat, x: CGFloat, y: CGFloat) -> AttributeComponent {
    let shadow = NSShadow()
    shadow.shadowColor = color
    shadow.shadowBlurRadius = radius
    shadow.shadowOffset = .init(width: x, height: y)
    return attributes([.shadow: shadow])
  }
  
  func strikethrough(style: NSUnderlineStyle, color: UIColor? = nil) -> AttributeComponent {
    if let color = color {
      return attributes([.strikethroughStyle: style.rawValue,
                         .strikethroughColor: color])
    } else {
      return attributes([.strikethroughStyle: style.rawValue])
    }
  }
  
  func stroke(width: CGFloat, color: UIColor? = nil) -> AttributeComponent {
    if let color = color {
      return attributes([.strokeWidth: width,
                         .strokeColor: color])
    } else {
      return attributes([.strokeWidth: width])
    }
  }
  
  func textEffect(_ textEffect: NSAttributedString.TextEffectStyle) -> AttributeComponent {
    attributes([.textEffect: textEffect])
  }
  
  func underline(_ style: NSUnderlineStyle, color: UIColor? = nil) -> AttributeComponent {
    if let color = color {
      return attributes([.underlineStyle: style.rawValue,
                         .underlineColor: color])
    } else {
      return attributes([.underlineStyle: style.rawValue])
    }
  }
  
  func writingDirection(_ writingDirection: NSWritingDirection) -> AttributeComponent {
    attributes([.writingDirection: writingDirection.rawValue])
  }
  
#if canImport(AppKit)
  func vertical() -> AttributeComponent {
    attributes([.verticalGlyphForm: 1])
  }
#endif
}

// MARK: - Paragraph Style Modifiers

public extension AttributeComponent {
  func paragraphStyle(_ paragraphStyle: NSParagraphStyle) -> AttributeComponent {
    attributes([.paragraphStyle: paragraphStyle])
  }
  
  func paragraphStyle(_ paragraphStyle: NSMutableParagraphStyle) -> AttributeComponent {
    attributes([.paragraphStyle: paragraphStyle])
  }
  
  private func getMutableParagraphStyle() -> NSMutableParagraphStyle {
    if let mps = attributes[.paragraphStyle] as? NSMutableParagraphStyle {
      return mps
    } else if let ps = attributes[.paragraphStyle] as? NSParagraphStyle,
              let mps = ps.mutableCopy() as? NSMutableParagraphStyle
    {
      return mps
    } else {
      return NSMutableParagraphStyle()
    }
  }
  
  func alignment(_ alignment: NSTextAlignment) -> AttributeComponent {
    let paragraphStyle = getMutableParagraphStyle()
    paragraphStyle.alignment = alignment
    return self.paragraphStyle(paragraphStyle)
  }
  
  func firstLineHeadIndent(_ indent: CGFloat) -> AttributeComponent {
    let paragraphStyle = getMutableParagraphStyle()
    paragraphStyle.firstLineHeadIndent = indent
    return self.paragraphStyle(paragraphStyle)
  }
  
  func headIndent(_ indent: CGFloat) -> AttributeComponent {
    let paragraphStyle = getMutableParagraphStyle()
    paragraphStyle.headIndent = indent
    return self.paragraphStyle(paragraphStyle)
  }
  
  func tailIndent(_ indent: CGFloat) -> AttributeComponent {
    let paragraphStyle = getMutableParagraphStyle()
    paragraphStyle.tailIndent = indent
    return self.paragraphStyle(paragraphStyle)
  }
  
  func lineBreakeMode(_ lineBreakMode: NSLineBreakMode) -> AttributeComponent {
    let paragraphStyle = getMutableParagraphStyle()
    paragraphStyle.lineBreakMode = lineBreakMode
    return self.paragraphStyle(paragraphStyle)
  }
  
  func lineHeight(multiple: CGFloat = 0, maximum: CGFloat = 0, minimum: CGFloat) -> AttributeComponent {
    let paragraphStyle = getMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = multiple
    paragraphStyle.maximumLineHeight = maximum
    paragraphStyle.minimumLineHeight = minimum
    return self.paragraphStyle(paragraphStyle)
  }
  
  func lineSpacing(_ spacing: CGFloat) -> AttributeComponent {
    let paragraphStyle = getMutableParagraphStyle()
    paragraphStyle.lineSpacing = spacing
    return self.paragraphStyle(paragraphStyle)
  }
  
  func paragraphSpacing(_ spacing: CGFloat, before: CGFloat = 0) -> AttributeComponent {
    let paragraphStyle = getMutableParagraphStyle()
    paragraphStyle.paragraphSpacing = spacing
    paragraphStyle.paragraphSpacingBefore = before
    return self.paragraphStyle(paragraphStyle)
  }
  
  func baseWritingDirection(_ baseWritingDirection: NSWritingDirection) -> AttributeComponent {
    let paragraphStyle = getMutableParagraphStyle()
    paragraphStyle.baseWritingDirection = baseWritingDirection
    return self.paragraphStyle(paragraphStyle)
  }
  
  func hyphenationFactor(_ hyphenationFactor: Float) -> AttributeComponent {
    let paragraphStyle = getMutableParagraphStyle()
    paragraphStyle.hyphenationFactor = hyphenationFactor
    return self.paragraphStyle(paragraphStyle)
  }
  
  @available(iOS 9.0, tvOS 9.0, watchOS 2.0, OSX 10.11, *)
  func allowsDefaultTighteningForTruncation() -> AttributeComponent {
    let paragraphStyle = getMutableParagraphStyle()
    paragraphStyle.allowsDefaultTighteningForTruncation = true
    return self.paragraphStyle(paragraphStyle)
  }
  
  func tabsStops(_ tabStops: [NSTextTab], defaultInterval: CGFloat = 0) -> AttributeComponent {
    let paragraphStyle = getMutableParagraphStyle()
    paragraphStyle.tabStops = tabStops
    paragraphStyle.defaultTabInterval = defaultInterval
    return self.paragraphStyle(paragraphStyle)
  }
  
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
  func textBlocks(_ textBlocks: [NSTextBlock]) -> AttributeComponent {
    let paragraphStyle = getMutableParagraphStyle()
    paragraphStyle.textBlocks = textBlocks
    return self.paragraphStyle(paragraphStyle)
  }
  
  func textLists(_ textLists: [NSTextList]) -> AttributeComponent {
    let paragraphStyle = getMutableParagraphStyle()
    paragraphStyle.textLists = textLists
    return self.paragraphStyle(paragraphStyle)
  }
  
  func tighteningFactorForTruncation(_ tighteningFactorForTruncation: Float) -> AttributeComponent {
    let paragraphStyle = getMutableParagraphStyle()
    paragraphStyle.tighteningFactorForTruncation = tighteningFactorForTruncation
    return self.paragraphStyle(paragraphStyle)
  }
  
  func headerLevel(_ headerLevel: Int) -> AttributeComponent {
    let paragraphStyle = getMutableParagraphStyle()
    paragraphStyle.headerLevel = headerLevel
    return self.paragraphStyle(paragraphStyle)
  }
#endif
}

public typealias AText = NSAttributedString.AttrText

public extension NSAttributedString {
  struct AttrText: AttributeComponent {
    
    public init(_ string: String, attributes: Attributes = [:]) {
      self.string = string
      self.attributes = attributes
    }
    
    // MARK: Public
    
    public let string: String
    public let attributes: Attributes
  }
}


public typealias Empty = NSAttributedString.Empty
public typealias Space = NSAttributedString.Space
public typealias LineBreak = NSAttributedString.LineBreak

public extension NSAttributedString {
  struct Empty: AttributeComponent {
    // MARK: Lifecycle
    
    public init() {}
    
    // MARK: Public
    
    public let string: String = ""
    public let attributes: Attributes = [:]
  }
  
  struct Space: AttributeComponent {
    // MARK: Lifecycle
    
    public init() {}
    
    // MARK: Public
    
    public let string: String = " "
    public let attributes: Attributes = [:]
  }
  
  struct LineBreak: AttributeComponent {
    // MARK: Lifecycle
    
    public init() {}
    
    // MARK: Public
    
    public let string: String = "\n"
    public let attributes: Attributes = [:]
  }
}
