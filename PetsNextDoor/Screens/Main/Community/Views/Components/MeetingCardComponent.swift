//
//  MeetingCardComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/18.
//

import Foundation
import UIKit
import SwiftUI

final class MeetingCardComponent: Component, TouchableComponent {
  
  typealias ContentView = UIView
  typealias ViewModel   = MeetingCardViewModel
  
  var viewModel: ViewModel
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
  }
  
  @MainActor
  func createContentView() -> ContentView {
    let config = UIHostingConfiguration { MeetingCardView() }
			.margins(.all, 0)
    return config.makeContentView()
  }
  
  func render(contentView: ContentView) {
    contentView.onTap { [weak self] in
      guard let self else { return }
      self.onTouchAction?(self)
    }
  }
  
  func contentHeight() -> CGFloat? {
    112
  }
  
  //MARK: - TouchableComponent
  
  var onTouchAction: ((MeetingCardComponent) -> Void)?
  
  func onTouch(_ action: @escaping ((MeetingCardComponent) -> Void)) -> Self {
    self.onTouchAction = action
    return self
  }
}
