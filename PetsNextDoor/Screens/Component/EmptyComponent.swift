//
//  EmptyComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/05.
//

import UIKit
import Combine 

final class EmptyComponent: Component {
  
  var subscriptions = Set<AnyCancellable>()
  
  typealias ContentView = EmptyView
  
  struct Context {
    let height: CGFloat
    let backgroundColor: UIColor
  }

  var contentView: EmptyView?
  var context: Context
  
  var height: CGFloat { context.height }
  
  init(height: CGFloat, backgroundColor: UIColor = PND.Colors.commonWhite) {
    self.context = .init(height: height, backgroundColor: backgroundColor)
  }
  
  func createContentView() -> EmptyView {
    let view = EmptyView(height: height, backgroundColor: context.backgroundColor)
    self.contentView = view
    return view
  }
  
  func render(contentView: EmptyView, withContext context: Context) {
    
  }
}
