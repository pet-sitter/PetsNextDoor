//
//  Publisher+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import Foundation
import Combine

//MARK: - TypeAliases

typealias TriggerSubject<T>       = PassthroughSubject<T, Never>

typealias SingleValueSubject<T>   = CurrentValueSubject<T, Never>
typealias SingleValuePublisher<T> = Publisher<T, Never>

//MARK: - Extension Methods

extension Publisher where Self.Failure == Never {
  
  func assignNoRetain<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable where Root: AnyObject {
    sink { [weak object] (value) in
      object?[keyPath: keyPath] = value
    }
  }
  
  func withStrong<T: AnyObject>(_ object: T) -> Publishers.CompactMap<Self, (T, Self.Output)> {
    compactMap { [weak object] output in
      guard let object else { return nil }
      return (object, output)
    }
  }
  
  func withWeak<T: AnyObject>(_ object: T) -> Publishers.CompactMap<Self, (T?, Self.Output)> {
    compactMap { [weak object] output in
      return (object, output)
    }
  }

  
  func ifFalse(_ actionBlock: @escaping (() -> Void)) -> Publishers.HandleEvents<Self> where Self.Output == Bool {
    handleEvents(receiveOutput: { boolValue in
      if boolValue == false {
        actionBlock()
      }
    })
  }
  
  func ifTrue(_ actionBlock: @escaping (() -> Void)) -> Publishers.HandleEvents<Self> where Self.Output == Bool {
    handleEvents(receiveOutput: { boolValue in
      if boolValue == true {
        actionBlock()
      }
    })
  }
  
  func receiveOnMainQueue<S>(on scheduler: S = DispatchQueue.main) -> Publishers.ReceiveOn<Self, S> where S : Scheduler {
    receive(on: scheduler)
  }
}
