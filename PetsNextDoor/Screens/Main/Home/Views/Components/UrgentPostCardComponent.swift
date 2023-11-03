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
  typealias ViewModel   = UrgentPostCardViewModel
  
  var contentView: ContentView?
  var viewModel: ViewModel
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
  }
  
  func createContentView() -> ContentView {
    UrgentPostCardView()
  }
  
  func render(contentView: UrgentPostCardView) {
    contentView.configure(viewModel: viewModel)
  }
  
  func contentHeight() -> CGFloat? {
    ContentView.defaultHeight
  }
}
