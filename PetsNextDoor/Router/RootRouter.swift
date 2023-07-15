//
//  RootRouter.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import Foundation
import Combine

final class RootRouter: Routable {
  
  // as shared property?
  
  private(set) var outputStream: AsyncPublisher<PassthroughSubject<ObservableOutput, Never>>
  
  init(outputStream: AsyncPublisher<PassthroughSubject<ObservableOutput, Never>>) {
    self.outputStream = outputStream
    observeOutputStream()
  }

  func observeOutputStream() {
    Task {
      for await output in outputStream {
        switch output {
          
        default: break
        }
      }
    }
  }
}
