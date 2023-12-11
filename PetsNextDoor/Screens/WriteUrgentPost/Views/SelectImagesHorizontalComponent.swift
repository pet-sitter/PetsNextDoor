//
//  SelectImagesHorizontalComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/11.
//

import Foundation
import SwiftUI
import UIKit

final class SelectImagesHorizontalComponent: Component {
  
  typealias ContentView = UIView
  typealias ViewModel   = SelectImagesHorizontalViewModel
  
  var viewModel: ViewModel
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
  }
  
  @MainActor
  func createContentView() -> ContentView {
    let config = UIHostingConfiguration { SelectImagesHorizontalView(viewModel: self.viewModel) }
      .margins(.all, 0)
    return config.makeContentView()
  }
  
  func render(contentView: ContentView) {
    


  }
  
  func contentHeight() -> CGFloat? {
    110
  }
}
