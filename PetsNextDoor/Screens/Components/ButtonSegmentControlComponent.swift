//
//  ButtonSegmentControlComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/08.
//

import Foundation

final class ButtonSegmentControlComponent: Component, ContainsSegments {
  
  typealias ContentView = ButtonSegmentControlView
  typealias ViewModel   = ButtoSegmentControlViewModel
  
  var viewModel: ViewModel
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
  }
  
  func createContentView() -> ButtonSegmentControlView {
    ButtonSegmentControlView(segmentTitles: viewModel.segmentTitles)
  }
  
  func render(contentView: ButtonSegmentControlView) {
    contentView.onSegmentTap = onSegmentChange
  }
  
  private(set) var onSegmentChange: ((Int) -> Void)?
  
  func onSegmentChange(_ action: ((Int) -> Void)?) -> Self {
    self.onSegmentChange = action
    return self
  }
}
