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
        .padding(.leading, PND.Metrics.defaultSpacing)
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

struct LoadingViewModifier: ViewModifier {
  
  @StateObject private var controller = LoadingController.shared
  
  func body(content: Content) -> some View {
    ZStack {
      content
      
      if controller.isLoading {
        Group {
          
          Color
            .black
            .opacity(0.1)
            .ignoresSafeArea()
          
          ProgressView()
            .tint(.white)
        }
        .allowsHitTesting(!controller.allowTouch)
        .zIndex(1)
      }
    }
    .animation(.spring(duration: 0.3), value: controller.isLoading)
  }
}

struct PlainListModifier: ViewModifier {
  
  func body(content: Content) -> some View {
    content
      .background(.white)
      .listRowSeparator(.hidden)
      .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
  }
}

extension View {
  
  func onViewDidLoad(_ task: @escaping () async -> Void) -> some View {
    modifier(ViewDidLoadModifier(task: task))
  }
  
  func size(_ value: CGFloat) -> some View {
    frame(width: value, height: value)
  }
  
  @ViewBuilder
  func `if`<Content: View>(
    _ condition: Bool,
    _ apply: (Self) -> Content
  ) -> some View {
    if condition {
      apply(self)
    } else {
      self
    }
  }
  
  func onDragDownGesture(_ task: @escaping () -> Void) -> some View {
    self
      .gesture(
        DragGesture().onEnded { value in
          if value.location.y - value.startLocation.y > 150 {
            task()
          }
        }
      )
  }
}
