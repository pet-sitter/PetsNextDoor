//
//  ButtonComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/04.
//

import Foundation
import Combine
import SnapKit

final class BottomButtonComponent: Component, TouchableComponent {
  
  var subscriptions = Set<AnyCancellable>()
  
  typealias ContentView = BaseBottomButton
  
  struct Context {
    let buttonTitle: String
  }
  
  var contentView: ContentView?
  var context: Context
  
  var height: CGFloat { ContentView.defaultHeight }
  
  var onTouchAction: ((any Component) -> Void)?

  init(context: Context) {
    self.context = context
  }
  
  func createContentView() -> ContentView {
    let view = BaseBottomButton(title: context.buttonTitle)
    self.contentView = view
    return view
  }
  
  func render(contentView: ContentView, withContext context: Context) {
    contentView.snp.remakeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(ContentView.defaultHeight)
    }
    
    contentView.controlEventPublisher(for: .touchUpInside)
      .withStrong(self)
      .sink { owner, _ in
        owner.onTouchAction?(owner)
      }
      .store(in: &subscriptions)
  }

  func onTouch(_ action: @escaping ComponentAction) -> Self {
    self.onTouchAction = action
    return self
  }
}


