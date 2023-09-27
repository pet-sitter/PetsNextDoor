//
//  BaseButton.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/27.
//

import UIKit
import Combine

class BaseButton: UIButton {
  
  private var subscriptions = Set<AnyCancellable>()
  
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  @available(*, unavailable) required init?(coder: NSCoder) { fatalError("Not implemented") }
  
  convenience init(isEnabled: PNDPublisher<Bool>) {
    self.init()
    isEnabled
      .sink { [weak self] isEnabled in
        self?.isEnabled = isEnabled
        self?.alpha = isEnabled ? 1.0 : 0.5
      }
      .store(in: &subscriptions)
  }
  
  private func configureUI() {
    
  }
}
