//
//  LoadingManager.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/04/16.
//

import Foundation
import SwiftUI

extension View {
  
  func enableGlobalLoading() -> some View {
    modifier(LoadingViewModifier())
  }
  
  func isLoading(_ isLoading: Bool, allowsTouch: Bool = true) -> some View {
    Task {
      await MainActor.run {
        LoadingController.shared.isLoading  = isLoading
        LoadingController.shared.allowTouch = allowsTouch
      }
    }
    return self
  }
}

@MainActor
final class LoadingController: ObservableObject {
  
  static let shared = LoadingController()
  
  private init() {}
  
  @Published var isLoading: Bool  = false
  @Published var allowTouch: Bool = false
  
  
}
