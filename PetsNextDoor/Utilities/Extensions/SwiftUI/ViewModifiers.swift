//
//  ViewModifiers.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/18.
//

import SwiftUI

struct HeaderTitleModifier: ViewModifier {
  
  func body(content: Content) -> some View {
    HStack(spacing: 0) {
      content
        .font(.system(size: 20, weight: .bold))
        .multilineTextAlignment(.leading)
        .padding(.leading, 20)
      Spacer()
    }
  }
}

struct TextLeadingModifier: ViewModifier {
  
  func body(content: Content) -> some View {
    HStack(spacing: 0) {
      content
      Spacer()
    }
  }
}

struct TextTrailingModifier: ViewModifier {
  
  func body(content: Content) -> some View {
    HStack(spacing: 0) {
      Spacer()
      content
    }
  }
}

struct BackgroundDebugModifier: ViewModifier {
  
  var color: Color = Color.blue.opacity(0.23)
  
  func body(content: Content) -> some View {
    content
      .background(color)
  }
}

struct ViewDidLoadModifier: ViewModifier {
  
  @State private var didLoadView: Bool = false
  let task: () async -> Void
  
  func body(content: Content) -> some View {
    content
      .task {
        guard didLoadView == false else { return }
        didLoadView = true
        await task()
      }
  }
}

extension View {
  
  func onViewDidLoad(_ task: @escaping () async -> Void) -> some View {
    modifier(ViewDidLoadModifier(task: task))
  }
}
