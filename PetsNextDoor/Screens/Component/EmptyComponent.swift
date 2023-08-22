//
//  EmptyComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/05.
//

import Foundation
import Combine 

final class EmptyComponent: Component {
  
  var subscriptions = Set<AnyCancellable>()
  
  typealias ContentView = EmptyView
  
  struct Context {
    let height: CGFloat
  }

  var contentView: EmptyView?
  var context: Context
  
  var height: CGFloat { context.height }
  
  init(height: CGFloat) {
    self.context = .init(height: height)
  }
  
  func createContentView() -> EmptyView {
    let view = EmptyView(height: height)
    self.contentView = view
    return view
  }
  
  func render(contentView: EmptyView, withContext context: Context) {
    
  }
}
