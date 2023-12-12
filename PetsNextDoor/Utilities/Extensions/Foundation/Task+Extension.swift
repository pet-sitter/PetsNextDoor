//
//  Task+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/12.
//

import Foundation

extension Task where Failure == Error {
  
  @discardableResult
  static func delayed(
    byTimeInterval delayInterval: TimeInterval,
    priority: TaskPriority? = nil,
    operation: @escaping @Sendable () async throws -> Success
  ) -> Task {
    Task(priority: priority) {
      let delay = UInt64(delayInterval * 1_000_000_000)
      try await Task<Never, Never>.sleep(nanoseconds: delay)
      return try await operation()
    }
  }
}
