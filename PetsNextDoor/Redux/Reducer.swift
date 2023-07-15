//
//  Reducer.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/09.
//

import Foundation

@MainActor
protocol Reducer<State, Action, Feedback, Output>: AnyObject where State: Equatable, Output: ObservableOutput {
  
  associatedtype State
  associatedtype Action
  associatedtype Feedback = Never
  associatedtype Output   
  
  func reduce(
    message: Message<Action, Feedback>,
    into state: inout State
  ) -> Effect<Feedback, Output>
}

enum Message<Action, Feedback>: Sendable where Action: Sendable, Feedback: Sendable {
  case action(Action)
  case feedback(Feedback)
}


protocol MiddleWare {}

protocol ObservableOutput {}


