//
//  CountDownTimer.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/26.
//

import UIKit

final class CountDownTimer {
  
  private var timer: Timer?
  private var remainingTime: TimeInterval
  private var countdownLabel: UILabel
  private var timerDidEndAction: (() -> Void)?
  
  init(milliseconds: Int, countdownLabel: UILabel) {
    self.remainingTime = TimeInterval(milliseconds) / 1000.0
    self.countdownLabel = countdownLabel
  }
  
  func start() {
    if timer == nil {
      timer = Timer.scheduledTimer(
        timeInterval: 1,
        target: self,
        selector: #selector(updateTimer),
        userInfo: nil,
        repeats: true
      )
    }
  }
  
  func stop() {
    timer?.invalidate()
    timer = nil
  }
  
  func onTimerEnd(action: @escaping () -> Void) {
    self.timerDidEndAction = action
  }
  
  @objc private func updateTimer() {
    if remainingTime > 0 {
      remainingTime -= 1
      updateCountdownLabel()
    } else {
      stop()
      timerDidEndAction?()
    }
  }
  
  private func updateCountdownLabel() {
    let minutes = (Int(remainingTime) % 3600) / 60
    let seconds = Int(remainingTime) % 60
    
    let text = String(format: "%02d:%02d", minutes, seconds)
    countdownLabel.text = text
  }
}
