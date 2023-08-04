//
//  Keyboard.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/30.
//

import Combine
import UIKit

enum KeyboardEvent: Equatable {
  case unknown
  case willPresent(from:CGRect, to:CGRect, duration:TimeInterval, curve:UIView.AnimationCurve)
  case willDismiss(from:CGRect, to:CGRect, duration:TimeInterval, curve:UIView.AnimationCurve)
  case didPresent(from:CGRect, to:CGRect, duration:TimeInterval, curve:UIView.AnimationCurve)
  case didDismiss(from:CGRect, to:CGRect, duration:TimeInterval, curve:UIView.AnimationCurve)
  
  var isPresenting: Bool {
    switch self {
    case .willPresent, .didPresent:
      return true
    default:
      return false
    }
  }
}


final class Keyboard {
  
  static var changed: AnyPublisher<KeyboardEvent,Never> {
    Keyboard.shared.changed.eraseToAnyPublisher()
  }
  
  static var current: KeyboardEvent {
    Keyboard.shared.changed.value
  }
  
  static let shared = Keyboard()
  private var subscriptions = Set<AnyCancellable>()
  private let changed = CurrentValueSubject<KeyboardEvent,Never>(.unknown)
  
  private init() {
    observeKeyboardEvent()
  }
  
  private func observeKeyboardEvent() {
    NotificationCenter
      .default
      .publisher(for: UIApplication.keyboardWillShowNotification)
      .sink(receiveValue: { [weak self] info in
        self?.changed.send(.willPresent(
          from: info.asKeyboardFrameBegin() ?? .zero,
          to: info.asKeyboardFrameEnd() ?? .zero,
          duration: info.asKeyboardAnimationDuration() ?? 0,
          curve: info.asKeyboardAnimationCurve() ?? .linear))
      })
      .store(in: &subscriptions)
    
    NotificationCenter
      .default
      .publisher(for: UIApplication.keyboardDidShowNotification)
      .sink(receiveValue: { [weak self] info in
        self?.changed.send(.didPresent(
          from: info.asKeyboardFrameBegin() ?? .zero,
          to: info.asKeyboardFrameEnd() ?? .zero,
          duration: info.asKeyboardAnimationDuration() ?? 0,
          curve: info.asKeyboardAnimationCurve() ?? .linear))
      })
      .store(in: &subscriptions)
    
    
    NotificationCenter
      .default
      .publisher(for: UIApplication.keyboardWillHideNotification)
      .sink(receiveValue: { [weak self] info in
        self?.changed.send(.willDismiss(
          from: info.asKeyboardFrameBegin() ?? .zero,
          to: info.asKeyboardFrameEnd() ?? .zero,
          duration: info.asKeyboardAnimationDuration() ?? 0,
          curve: info.asKeyboardAnimationCurve() ?? .linear))
      })
      .store(in: &subscriptions)
    
    NotificationCenter
      .default
      .publisher(for: UIApplication.keyboardDidHideNotification)
      .sink(receiveValue: { [weak self] info in
        self?.changed.send(.didDismiss(
          from: info.asKeyboardFrameBegin() ?? .zero,
          to: info.asKeyboardFrameEnd() ?? .zero,
          duration: info.asKeyboardAnimationDuration() ?? 0,
          curve: info.asKeyboardAnimationCurve() ?? .linear))
      })
      .store(in: &subscriptions)
    
  }
  
  static func dismiss() {
    Task { @MainActor in
      UIApplication
        .shared
        .sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
  }
}



extension KeyboardEvent {
  var fromFrame:CGRect {
    switch self {
    case .unknown:
      return .zero
    case let .willPresent(value, _, _, _):
      return value
    case let .didPresent(value, _, _, _):
      return value
    case let .willDismiss(value, _, _, _):
      return value
    case let .didDismiss(value, _, _, _):
      return value
    }
  }
  
  var toFrame:CGRect {
    switch self {
    case .unknown:
      return .zero
    case let .willPresent(_, value, _, _):
      return value
    case let .didPresent(_, value, _, _):
      return value
    case let .willDismiss(_, value, _, _):
      return value
    case let .didDismiss(_, value, _, _):
      return value
    }
  }
  
  var duration:TimeInterval {
    switch self {
    case .unknown:
      return .zero
    case let .willPresent(_, _, value, _):
      return value
    case let .didPresent(_, _, value, _):
      return value
    case let .willDismiss(_, _, value, _):
      return value
    case let .didDismiss(_, _, value, _):
      return value
    }
  }
  
  var curve:UIView.AnimationCurve {
    switch self {
    case .unknown:
      return .linear
    case let .willPresent(_, _, _, value):
      return value
    case let .didPresent(_, _, _, value):
      return value
    case let .willDismiss(_, _, _, value):
      return value
    case let .didDismiss(_, _, _, value):
      return value
    }
  }
  
}



extension Notification {

  func asKeyboardFrameBegin() -> CGRect? {

    return (self.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue

  }

  func asKeyboardFrameEnd() -> CGRect? {

    return (self.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue

  }

  func asKeyboardAnimationDuration() -> TimeInterval? {

    return (self.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval)

  }

  func asKeyboardAnimationCurve() -> UIView.AnimationCurve? {

    guard let animationCurveValue = self.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int, let animationCurve = UIView.AnimationCurve(rawValue: animationCurveValue) else { return nil }

    return animationCurve

  }

}
