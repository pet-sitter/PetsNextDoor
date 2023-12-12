//
//  ErrorTracker.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/12.
//

import Foundation
import Combine

public typealias ErrorTracker = PassthroughSubject<Error, Never>

extension Publisher where Failure: Error {
  public func trackError(_ errorTracker: ErrorTracker) -> AnyPublisher<Output, Failure> {
    return handleEvents(receiveCompletion: { completion in
      if case let .failure(error) = completion {
        errorTracker.send(error)
      }
    })
    .eraseToAnyPublisher()
  }
}

