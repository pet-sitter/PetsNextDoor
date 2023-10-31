//
//  ComponentTableViewCell.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/24.
//

import UIKit

class ComponentTableViewCell: UITableViewCell, ComponentRenderable {

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) { fatalError("") }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .clear
    containerView.backgroundColor = .clear
    selectionStyle = .none
  }
  
  func render(component: some Component) {
    
    let contentView = component.createContentView()
    
    guard contentView.subviews.contains(contentView) == false else {
      component.render(contentView: contentView, withViewModel: component.viewModel)
      return
    }
    
    containerView.addSubview(contentView)
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    component.render(contentView: contentView, withViewModel: component.viewModel)
  }
}
