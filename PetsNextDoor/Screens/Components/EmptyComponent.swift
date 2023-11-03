//
//  EmptyComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/05.
//

import UIKit
import Combine 

final class EmptyComponent: Component {
  
  typealias ContentView = EmptyView
  typealias ViewModel   = EmptyViewModel
  
  var viewModel: ViewModel
  
  init(height: CGFloat, backgroundColor: UIColor = PND.Colors.commonWhite) {
    self.viewModel = .init(height: height, backgroundColor: backgroundColor)
  }
  
  init(viewModel: EmptyViewModel) {
    self.viewModel = viewModel
  }
  
  func createContentView() -> EmptyView {
    EmptyView()
  }
  
  func render(contentView: EmptyView) {
    contentView.configure(viewModel: viewModel)
  }
  
  func contentHeight() -> CGFloat? {
    viewModel.height
  }
  
}
