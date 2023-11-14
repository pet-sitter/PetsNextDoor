//
//  BaseTextViewComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/14.
//

import Foundation

final class BaseTextViewComponent: Component, ContainsTextView {
  
  typealias ContentView = BaseTextView
  typealias ViewModel   = BaseTextViewModel
  
  var viewModel: ViewModel
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
  }
  
  func createContentView() -> ContentView {
    BaseTextView()
  }
  
  func render(contentView: ContentView) {
    
    contentView.configure(viewModel: viewModel)
    
    contentView.onTextChange = onEditingChanged
  }
  
  func contentHeight() -> CGFloat? {
    150.0
  }
  
  
  //MARK: - ContainsTextView
  
  var onEditingChanged: ((String?) -> Void)?
  
  func onEditingChanged(_ action: @escaping ((String?) -> Void)) -> Self {
    self.onEditingChanged = action
    return self
  }
  
}
