//
//  Effect.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/09.
//

import Foundation

struct Effect<Feedback, Output> {
  
  typealias Operation = (@Sendable @escaping (Feedback) async -> Void) async -> Void
  
  let output: Output?
  let operation: Operation
  
  init(
    output: Output?,
    operation: @escaping Operation
  ) {
    self.output = output
    self.operation = operation
  }
}

extension Effect {
  static var none: Self {
    return .init(output: nil) { _ in }
  }
  
  static func output(_ output: Output) -> Self {
    return .init(output: output) { _ in }
  }
  
  static func run(operation: @escaping Operation) -> Self {
    self.init(output: nil, operation: operation)
  }
}
