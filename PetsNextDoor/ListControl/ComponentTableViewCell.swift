//
//  ComponentTableViewCell.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/24.
//

import UIKit
import SwiftUI

class ComponentTableViewCell: UITableViewCell, ComponentRenderable {
  
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) { fatalError("") }

  private var renderedComponent: (any Component)?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .clear
    containerView.backgroundColor = .clear
    selectionStyle = .none
  }
  
  func render(component: some Component) {
    
    guard renderedComponent != nil else {
      
      let contentView   = component.createContentView()
      renderedComponent = component

      
      if let uiView = contentView as? UIView {
        
        containerView.addSubview(uiView)
        uiView.snp.makeConstraints { $0.edges.equalToSuperview() }
      }

      component.render(contentView: contentView)
      return
    }
    
  }
}



import SwiftUI

final class ContainerView<Content: View>: UIView {
  
  var configuration: UIHostingConfiguration<Content, SwiftUI.EmptyView>
  
  init(_ swiftUIView: Content) {
    self.configuration = UIHostingConfiguration { swiftUIView }
    
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

