//
//  OnTouchModifer.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/04.
//

import Foundation

struct OnTouchModifier<Wrapped: Component>: ComponentModifier where Wrapped.ContentView: Touchable {

  typealias ContentView = Wrapped.ContentView
  typealias Context     = Wrapped.Context
  
  let wrapped: Wrapped
  var context: Wrapped.Context { wrapped.context }
  var height: CGFloat { wrapped.height }
  
  let onTouch: (ContentView) -> Void
  
  func createContentView() -> Wrapped.ContentView {
    wrapped.createContentView()
  }
  
  func render(contentView: ContentView, withContext context: Context) {
    wrapped.render(contentView: contentView, withContext: context)
    
    contentView.onTouchableAreaTap {
      print("✅ onTouchableAreaTap")
    }
  }
}



