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
//    MeetingCardView()
    let config = UIHostingConfiguration { MeetingCardViewSwiftUI() }
    return config.makeContentView()
  }
  
  func render(contentView: ContentView) {
//    contentView.configure(viewModel: viewModel)
    
    contentView.onTap { [weak self] in
      guard let self else { return }
      self.onTouchAction?(self)
    }
  }
  
  func contentHeight() -> CGFloat? {
//    ContentView.defaultHeight
    112
  }
  
  //MARK: - TouchableComponent
  
  var onTouchAction: ((MeetingCardComponent) -> Void)?
  
  func onTouch(_ action: @escaping ((MeetingCardComponent) -> Void)) -> Self {
    self.onTouchAction = action
    return self
  }
}
