//
//  CountDownLabel.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/27.
//

import UIKit
import Combine
import SnapKit

final class CountDownLabel: UILabel, ValueBindable {
  
  private var countDownTimer: CountDownTimer?
  
  private var onTimerEnd: (() -> Void)?
  
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) { fatalError("") }
  
  private func configureUI() {
    textColor = PND.Colors.commonRed
    font      = .systemFont(ofSize: 12, weight: .regular)
  }
  
  func configureTimer(milliseconds: Int) {
    
    if countDownTimer != nil { return }
    
    countDownTimer = CountDownTimer(milliseconds: milliseconds, countdownLabel: self)
    countDownTimer?.start()
    
    countDownTimer?.onTimerEnd { [weak self] in
      self?.onTimerEnd?()
    }
  }
  
  func onTimerEnd(_ action: @escaping () -> Void) -> Self {
    self.onTimerEnd = action
    return self
  }
  
  //MARK: - Value Observable
  
  private(set) var subscriptions: Set<AnyCancellable> = .init()
  
  typealias ObservingValue = Int?
  
  func bindValue(_ valuePublisher: PNDPublisher<ObservingValue>) -> Self {
    valuePublisher
      .compactMap { $0 }
      .sink { [weak self] milliseconds in
        self?.configureTimer(milliseconds: milliseconds)
      }
      .store(in: &subscriptions)
    return self
  }

}
