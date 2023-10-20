//
//  SelectPetComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/20.
//

import Foundation
import Combine

final class SelectPetComponent: Component, TouchableComponent {
  
  typealias ContentView = SelectPetView
  typealias Context     = SelectPetViewModel
  
  var subscriptions: Set<AnyCancellable> = .init()
  
  var contentView: SelectPetView?
  var context: SelectPetViewModel
  
  var height: CGFloat { ContentView.defaultHeight }
  
  init(context: Context) {
    self.context = context
  }
  
  func createContentView() -> SelectPetView {
    let view = SelectPetView()
    self.contentView = view
    return view
  }
  
  func render(contentView: SelectPetView, withContext context: SelectPetViewModel) {
    contentView.configure(with: context)
  }
  
  //MARK: - TouchableComponent
  
  var onTouchAction: ((any Component) -> Void)?
  
  func onTouch(_ action: @escaping ComponentAction) -> Self {
    self.onTouchAction = action
    return self
  }
  
  
}
