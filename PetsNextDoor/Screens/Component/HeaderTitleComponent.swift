//
//  HeaderTitleComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/30.
//

import Foundation
import Combine

final class HeaderTitleComponent: Component {
  
  typealias ContentView = HeaderTitleView
  typealias ViewModel   = HeaderTitleViewModel
  
  var subscriptions: Set<AnyCancellable> = .init()
  
  var contentView: HeaderTitleView?
  var viewModel: HeaderTitleViewModel
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
  }
  
  func createContentView() -> HeaderTitleView {
    HeaderTitleView()
  }
  
  func render(contentView: HeaderTitleView, withViewModel viewModel: HeaderTitleViewModel) {
    contentView.configure(viewModel: viewModel)
  }
  
  func contentHeight() -> CGFloat? {
    ContentView.defaultHeight
  }
}
