//
//  EmptyTextFieldComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/14.
//

import Foundation

final class EmptyTextFieldComponent: Component, ContainsTextField {
  
  typealias ContentView = BaseEmptyTextFieldView
  typealias ViewModel   = BaseEmptyTextFieldViewModel
  
  var viewModel: ViewModel
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
  }
  
  func createContentView() -> ContentView {
      BaseEmptyTextFieldView()
  }
  
  func render(contentView: ContentView) {
    
    contentView.configure(viewModel: viewModel)
    
    contentView.onTextChange = { [weak self] text in
      guard let self else { return }
      self.onEditingChanged?( (text, self) )
    }
  }
  
  func contentHeight() -> CGFloat? {
    ContentView.defaultHeight
  }
  
  //MARK: - ContainsTextField
  
  var onEditingChanged: (((String?, EmptyTextFieldComponent)) -> Void)?
  
  func onEditingChanged(_ action: @escaping (((String?, EmptyTextFieldComponent))) -> Void) -> Self {
    self.onEditingChanged = action
    return self
  }
}
