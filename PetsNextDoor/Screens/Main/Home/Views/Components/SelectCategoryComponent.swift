//
//  SelectCategoryComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/03.
//

import Foundation
import Combine

final class SelectCategoryComponent: Component {
  
  var subscriptions: Set<AnyCancellable> = .init()
  
  typealias ContentView = SelectCategoryView
  
  struct Context {
    
  }
  
  var contentView: SelectCategoryView?
  var context: Context
  
  var height: CGFloat { SelectCategoryView.defaultHeight }
  
  init(context: Context) {
    self.context = context
  }
  
  func createContentView() -> SelectCategoryView {
    let view = SelectCategoryView()
    
    return view
  }
  
  func render(contentView: SelectCategoryView, withContext context: Context) {
    contentView.onCategoryButtonTap = onCategoryChange
  }
  
  private var onCategoryChange: ((SelectCategoryView.Category) -> Void)?
  
  func onCategoryChange(_ action: ((SelectCategoryView.Category) -> Void)?) -> Self {
    self.onCategoryChange = action
    return self
  }
}
