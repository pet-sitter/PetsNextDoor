//
//  UrgentPostCardFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/08.
//

import Foundation
import Combine

final class UrgentPostCardComponent: Component, TouchableComponent {
  
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
    
    contentView.onTap { [weak self] in
      guard let self else { return }
      self.onTouchAction?(self)
    }
  }
  
  func contentHeight() -> CGFloat? {
    ContentView.defaultHeight
  }
  
  //MARK: - TouchableComponent
  
  var onTouchAction: ((UrgentPostCardComponent) -> Void)?
  
  func onTouch(_ action: @escaping ((UrgentPostCardComponent) -> Void)) -> Self {
    self.onTouchAction = action
    return self 
  }
}
