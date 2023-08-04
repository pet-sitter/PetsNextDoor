//
//  ButtonComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/04.
//

import Foundation

struct BottomButtonComponent: Component {

    
  typealias ContentView = BaseBottomButton
  
  struct Context {
    let buttonTitle: String
  }
  
  var height: CGFloat { ContentView.defaultHeight }
  
  var context: Context
  
  init(context: Context) {
    self.context = context
  }
  
  func createContentView() -> ContentView {
    BaseBottomButton(title: context.buttonTitle)
  }
  
  func render(contentView: ContentView, withContext context: Context) {
    
  }
}


