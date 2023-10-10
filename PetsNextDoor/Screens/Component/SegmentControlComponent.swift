//
//  SegmentControlComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/01.
//

import Foundation
import Combine

final class SegmentControlComponent: Component {
  
  var subscriptions: Set<AnyCancellable> = .init()
  
  typealias ContentView = SegmentControlView
  
  struct Context {
    let segmentTitles: [String]
  }
  
  var contentView: SegmentControlView?
  var context: Context
  
  var height: CGFloat { SegmentControlView.defaultHeight }
  
  init(context: Context) {
    self.context = context
  }
  
  func createContentView() -> SegmentControlView {
    let view = SegmentControlView(segmentTitles: context.segmentTitles)
    self.contentView = view
    return view
  }
  
  func render(contentView: SegmentControlView, withContext context: Context) {
    contentView.onSegmentTap = self.onSegmentChange
  }
  
  private var onSegmentChange: ((Int) -> Void)?
  
  func onSegmentChange(_ action: ((Int) -> Void)?) -> Self {
    self.onSegmentChange = action
    return self
  }
}
