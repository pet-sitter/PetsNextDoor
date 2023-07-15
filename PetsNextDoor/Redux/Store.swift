//
//  Store.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/03.
//

import Foundation
import Combine

@MainActor
@dynamicMemberLookup
class Store<State, Action, Feedback, Output> where State: Equatable, Action: Sendable, Feedback: Sendable, Output: ObservableOutput {
  
  @Published private(set) var state: State
  
  private let reducer: any Reducer<State, Action, Feedback, Output>
  
  private let stateSubject: CurrentValueSubject<State, Never>
  lazy var stateStream = stateSubject.removeDuplicates().values
  
  private let outputSubject: PassthroughSubject<ObservableOutput, Never> = .init()
  lazy var outputStream = outputSubject.values
  
  private var tasks: [Task<Void, Never>] = []
  
  deinit {
    tasks.forEach { $0.cancel() }
  }
  
  init(
    initialState: State,
    reducer: some Reducer<State, Action, Feedback, Output>
  ) {
    self.state    = initialState
    self.reducer  = reducer
    stateSubject  = .init(initialState)
  }
  
  @discardableResult
  func dispatch(_ message: Action) -> Task<Void, Never> {
    let task = Task { await dispatch(.action(message)) }
    tasks.append(task)
    return task
  }
  
  func dispatch(_ message: Action) async {
    await dispatch(.action(message))
  }
  
  private func dispatch(_ message: Message<Action, Feedback>) async {
    guard !Task.isCancelled else { return }
    
    let effect = reducer.reduce(message: message, into: &state)
    stateSubject.send(state)
    
    if let output = effect.output {
      outputSubject.send(output)
    }
    
    await effect.operation { [weak self] feedback in
      guard !Task.isCancelled else { return }
      
      await self?.dispatch(.feedback(feedback))
    }
  }
  
  subscript<Value>(dynamicMember keypath: KeyPath<State, Value>) -> Value {
    state[keyPath: keypath]
  }
}
