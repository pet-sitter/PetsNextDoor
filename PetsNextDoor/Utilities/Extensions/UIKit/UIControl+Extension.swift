//
//  UIAction+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/16.
//

import UIKit
import Combine
import CombineCocoa

extension UIControl {
  
  func onTapGesture(_ actionBlock: (() -> Void)?) {
    let action = UIAction {  _ in actionBlock?()}
    self.addAction(action, for: .touchUpInside)
  }
  
  func controlEventPublisher(for events: UIControl.Event) -> AnyPublisher<Void, Never> {
      Publishers.ControlEvent(control: self, events: events)
                .eraseToAnyPublisher()
  }
}
