//
//  Store.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/03.
//

import Foundation
import Combine

enum MiddleWares  {}
protocol Action   {}

typealias Reducer<State>    = (State, Action) -> State
typealias Middleware<State> = (State, Action) async -> Action?

enum MiddlewareType: Hashable {
  
  case printer
  
  func hash(into hasher: inout Hasher) {
    switch self {
    case .printer:
      hasher.combine(String(describing: self))
    }
  }
}


final class Store<State: Codable> {
  
  var isEnabled = true
  
  @Published private(set) var state: State
  
  var mainState: AnyPublisher<State, Never> {
    $state
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
  
  private let queue = DispatchQueue(label: "com.petsNextDoor.store", qos: .userInitiated)
  private let reducer: Reducer<State>
  private var middleWares: [MiddlewareType: Middleware<State>]
  
  
  init(
    initialState: State,
    reducer: @escaping Reducer<State>,
    middleWares: [MiddlewareType: Middleware<State>]
  ) {
    self.state        = initialState
    self.reducer      = reducer
    self.middleWares  = middleWares
  }
  
  
  func injectMiddleware(key: MiddlewareType) {
    switch key {
    
    case .printer:
      break
    }
  }
  
  
  func removeMiddleware(forKey key: MiddlewareType) {
    
  }
  
  
  func restoreState(_ state: State) {
    self.state = state
  }
  
  
  func dispatch(_ action: Action) {
    guard isEnabled else { return }
    
    queue.sync {
      self.dispatch(self.state, action)
    }
  }
  
  
  private func dispatch(_ currentState: State, _ action: Action) {
    let newState    = reducer(currentState, action)
    let middleWares = Array(middleWares.values)
    
    middleWares.forEach { middleWare in
      Task {
        if let action = await middleWare(newState, action) {
          dispatch(action)
        }
      }
    }
    state = newState
  }
  
}
