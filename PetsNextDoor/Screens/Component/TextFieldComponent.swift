//
//  TextFieldComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/30.
//

import Foundation

struct TextFieldComponent: Component {
  
  typealias ContentView = BaseTextFieldView
  
  struct Context {
    let textFieldPlaceHolder: String
  }
  
  var height: CGFloat { ContentView.defaultHeight }
  var context: Context
  
  init(context: Context) {
    self.context = context
  }
  
  func createContentView() -> ContentView {
    return BaseTextFieldView(textFieldPlaceHolder: context.textFieldPlaceHolder)
  }
  
  func render(contentView: ContentView, withContext context: Context) {
    
  }
}


