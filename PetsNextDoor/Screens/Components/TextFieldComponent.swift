//
//  TextFieldComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/30.
//

import UIKit
import Combine 

final class TextFieldComponent: Component, ContainsTextField {  
  
  var subscriptions = Set<AnyCancellable>()
  
  typealias ContentView = BaseTextFieldView
  typealias ViewModel   = BaseTextFieldViewModel

  var viewModel: ViewModel
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
  }
  
  func createContentView() -> ContentView {
    BaseTextFieldView()
  }
  
  func render(contentView: ContentView) {
    
    contentView.configure(viewModel: viewModel)
    
    contentView.textField.controlEventPublisher(for: .editingChanged)
      .withStrong(self)
      .sink { owner, _ in
        owner.onEditingChanged?( (contentView.textField.text, owner) )
      }
      .store(in: &subscriptions)
  }
  
  func contentHeight() -> CGFloat? {
    ContentView.defaultHeight
  }
  
  //MARK: - ContainsTextField
  
  private(set) var onEditingChanged: (( (String?, TextFieldComponent) ) -> Void)?
  
  func onEditingChanged(_ action: @escaping (((String?, TextFieldComponent))) -> Void) -> Self {
    self.onEditingChanged = action
    return self
  }
}
