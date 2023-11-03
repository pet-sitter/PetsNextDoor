//
//  SegmentControlComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/01.
//

import Foundation
import Combine

final class SegmentControlComponent: Component {
  
  typealias ContentView = SegmentControlView
  typealias ViewModel   = SegmentControlViewModel
  
  var viewModel: ViewModel
  
  var height: CGFloat { SegmentControlView.defaultHeight }
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
  }
  
  func createContentView() -> SegmentControlView {
    SegmentControlView(segmentTitles: viewModel.segmentTitles)
  }
  
  func render(contentView: SegmentControlView) {
    contentView.onSegmentTap = self.onSegmentChange
  }
  
  private var onSegmentChange: ((Int) -> Void)?
  
  func onSegmentChange(_ action: ((Int) -> Void)?) -> Self {
    self.onSegmentChange = action
    return self
  }
}
