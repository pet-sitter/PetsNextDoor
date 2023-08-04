//
//  Component.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/30.
//

import UIKit
import SnapKit

protocol Component: CellItemModelType, HeightProvidable {
  
  associatedtype ContentView: UIView
  associatedtype Context
  
  var context: Context { get }
  
  func createContentView() -> ContentView
  func render(contentView: ContentView, withContext context: Context)
  
}

extension Component where ContentView: Touchable {
  func onTouch(_ onTouch: @escaping (ContentView) -> Void) -> OnTouchModifier<Self> {
    OnTouchModifier(wrapped: self, onTouch: onTouch)
  }
}


protocol CellItemModelType {

}



// View 사이즈 계산법
protocol HeightProvidable {
  var height: CGFloat { get }
}


protocol CellItemModelBindable: IdentifierProvidable {
  func bind(cellItemModel: any CellItemModelType)
}


class ContainerCell<C: Component>: UITableViewCell, CellItemModelBindable {
  
  private var content: C.ContentView!
  
  func bind(cellItemModel: any CellItemModelType) {
    
    guard let component = cellItemModel as? C else { return }
        
    content = content ?? component.createContentView()
    
    guard contentView.subviews.contains(content) == false else {
      component.render(contentView: content, withContext: component.context)
      return
    }
    
    contentView.addSubview(content)
    
    content.snp.makeConstraints { $0.edges.equalToSuperview() }
    
    component.render(contentView: content, withContext: component.context)
  }
}


// 터치 가능 여부
protocol Touchable {
  func onTouchableAreaTap(_ action: @escaping () -> Void)
}

// 버튼 존재 여부 
protocol ContainsButton {
  
}
