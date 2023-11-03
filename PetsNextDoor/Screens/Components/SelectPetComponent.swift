//
//  SelectPetComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/20.
//

import Foundation
import Combine

final class SelectPetComponent: Component, TouchableComponent {
  
  typealias ContentView   = SelectPetView
  typealias ViewModel     = SelectPetViewModel
  
  var viewModel: SelectPetViewModel
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
  }
  
  func createContentView() -> SelectPetView {
    SelectPetView()
  }
  
  func render(contentView: SelectPetView) {
    
    contentView.configure(viewModel: viewModel)
    
    contentView.onTap = { [weak self] in
      guard let self else { return }
      onTouchAction?(self)
    }
  }
  
  func contentHeight() -> CGFloat? {
    ContentView.defaultHeight
  }
  
  //MARK: - TouchableComponent
  
  var onTouchAction: ((SelectPetComponent) -> Void)?
  
  func onTouch(_ action: @escaping ((SelectPetComponent) -> Void)) -> Self {
    self.onTouchAction = action
    return self
  }
}
