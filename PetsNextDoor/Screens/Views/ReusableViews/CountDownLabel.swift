//
//  CountDownLabel.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/27.
//

import UIKit
import Combine
import SnapKit

final class CountDownLabel: UILabel {
  
  private var countDownTimer: CountDownTimer?
  
  var onTimerEnd: (() -> Void)?
  
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    
    textColor = UIColor(hex: "#FF2727")
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
  
  
}
