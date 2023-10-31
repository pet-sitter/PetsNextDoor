//
//  ButtonComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/04.
//

import Foundation
import Combine
import SnapKit

final class BottomButtonComponent: Component, TouchableComponent, ValueBindable {

  var subscriptions = Set<AnyCancellable>()
  
  typealias ContentView = BaseBottomButton
  typealias ViewModel   = BaseBottomButtonViewModel
  
  var contentView: ContentView?
  var viewModel: ViewModel
  
  var height: CGFloat { ContentView.defaultHeight }

  init(viewModel: ViewModel) {
    self.viewModel = viewModel
  }
  
  func createContentView() -> ContentView {
    BaseBottomButton()
  }
  
  func render(contentView: ContentView, withViewModel viewModel: ViewModel) {
    
    contentView.configure(viewModel: viewModel)
        
    contentView.controlEventPublisher(for: .touchUpInside)
      .withStrong(self)
      .sink { owner, _ in
        owner.onTouchAction?(owner)
      }
      .store(in: &subscriptions)
  }
  
  //MARK: - TouchableComponent
  
  var onTouchAction: ((BottomButtonComponent) -> Void)?
  
  func onTouch(_ action: @escaping ((BottomButtonComponent) -> Void)) -> Self {
    self.onTouchAction = action
    return self
  }

  //MARK: - ValueBindable
  
  typealias ObservingValue = Bool
  
  @discardableResult
  func bindValue(_ valuePublisher: PNDPublisher<Bool>) -> Self {
    valuePublisher
      .receive(on: DispatchQueue.main)
      .withWeak(self)
      .sink { owner, isEnabled in
        owner?.contentView?.isEnabled = isEnabled
      }
      .store(in: &subscriptions)
    return self
  }
}


