//
//  UrgentPostCardFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/08.
//

import Foundation
import Combine

final class UrgentPostCardComponent: Component {
  
  var subscriptions = Set<AnyCancellable>()
  
  typealias ContentView = UrgentPostCardView
  
  struct Context {
    let postTitle: String
    let date: String
    let location: String
    let cost: String
  }
  
  var contentView: ContentView?
  var context: Context
  
  var height: CGFloat { ContentView.defaultHeight }
  
  init(context: Context) {
    self.context = context
  }
  
  func createContentView() -> ContentView {
    let view = UrgentPostCardView()
    view.titleLabel.text    = context.postTitle
    view.dateLabel.text     = context.date
    view.locationLabel.text = context.location
    view.costLabel.text     = context.cost
    return view
  }
  
  func render(contentView: UrgentPostCardView, withContext context: Context) {
    
  }
}
