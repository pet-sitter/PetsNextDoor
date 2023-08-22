//
//  TextFieldComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/30.
//

import Foundation
import Combine 

final class TextFieldComponent: Component, ContainsTextField {
  
  var subscriptions = Set<AnyCancellable>()
  
  typealias ContentView = BaseTextFieldView
  
  struct Context {
    let textFieldPlaceHolder: String
  }

  var contentView: ContentView?
  var context: Context
  
  var height: CGFloat { ContentView.defaultHeight }
  
  var onEditingChanged: (( (String?, any Component) ) -> Void)?
  
  init(context: Context) {
    self.context = context
  }
  
  func createContentView() -> ContentView {
    let view = BaseTextFieldView(textFieldPlaceHolder: context.textFieldPlaceHolder)
    self.contentView = view
    return view
  }
  
  func render(contentView: ContentView, withContext context: Context) {
    contentView.textField.controlEventPublisher(for: .editingChanged)
      .withStrong(self)
      .sink { owner, _ in
        owner.onEditingChanged?( (contentView.textField.text, owner) )
      }
      .store(in: &subscriptions)
  }
  
  func onEditingChanged(_ action: @escaping (((String?, any Component))) -> Void) -> Self {
    self.onEditingChanged = action
    return self
  }
}
