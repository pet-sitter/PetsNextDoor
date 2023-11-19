//
//  MeetingCardComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/18.
//

import Foundation

final class MeetingCardComponent: Component, TouchableComponent {
  
  typealias ContentView = MeetingCardView
  typealias ViewModel   = MeetingCardViewModel
  
  var viewModel: ViewModel
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
  }
  
  func createContentView() -> MeetingCardView {
    MeetingCardView()
  }
  
  func render(contentView: MeetingCardView) {
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
  
  var onTouchAction: ((MeetingCardComponent) -> Void)?
  
  func onTouch(_ action: @escaping ((MeetingCardComponent) -> Void)) -> Self {
    self.onTouchAction = action
    return self
  }
}
