//
//  SelectPetComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/20.
//

import Foundation
import Combine
import SwiftUI

final class SelectPetComponent: Component, TouchableComponent {
  
  typealias ContentView   = UIView
  typealias ViewModel     = SelectPetViewModel
  
  var viewModel: SelectPetViewModel
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
  }
  
  @MainActor
  func createContentView() -> ContentView {
    UIHostingConfiguration { SelectPetView(viewModel: self.viewModel, onDeleteButtonTapped: nil) }
      .margins(.all, 0)
      .makeContentView()
  }
  
  func render(contentView: ContentView) {
  }
  
  func contentHeight() -> CGFloat? {
    100
  }
  
  //MARK: - TouchableComponent
  
  var onTouchAction: ((SelectPetComponent) -> Void)?
  
  func onTouch(_ action: @escaping ((SelectPetComponent) -> Void)) -> Self {
    self.onTouchAction = action
    return self
  }
  
  var onDeleteAction: ((SelectPetComponent) -> Void)?
  
  func onDelete(_ action: @escaping ((SelectPetComponent) -> Void)) -> Self {
    self.onDeleteAction = action
    return self
  }
}
