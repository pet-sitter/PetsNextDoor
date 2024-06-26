//
//  Toast.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/30.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
  
  @State private var overlayWindow: UIWindow?
  
  let store: StoreOf<PNDRootFeature>
  
  var body: some View {
    Group {
      switch store.state {
      case .splash:
        ProgressView()
        
      case .login:
        if let store = store.scope(state: \.login, action: \.loginAction) {
          LoginView(store: store)
        }
        
      case .mainTab:
        if let store = store.scope(state: \.mainTab, action: \.mainTabBarAction) {
          MainTabBarView(store: store)
        }
      }
    }
    .animation(.spring, value: store.state)
    .onAppear {
      store.send(.onAppear)
      setOverlayWindow()
    }
  }
  
  
  private func setOverlayWindow() {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, overlayWindow == nil {
      let window = PassthroughWindow(windowScene: windowScene)
      window.backgroundColor = .clear
      
      let rootController = UIHostingController(rootView: ToastGroup())
      rootController.view.frame = windowScene.keyWindow?.frame ?? .zero
      rootController.view.backgroundColor = .clear
      
      
      window.rootViewController = rootController
      window.isHidden = false
      window.isUserInteractionEnabled = true
      window.tag = 1009
      
      overlayWindow = window
    }
  }
}


fileprivate class PassthroughWindow: UIWindow {
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    guard let view = super.hitTest(point, with: event) else { return nil }
    
    return rootViewController?.view == view ? nil : view
  }
}

final class Toast: ObservableObject {
  
  static let shared = Toast()
  
  @Published fileprivate var toasts: [ToastItem] = []
  
  func present(
    title: String,
    symbol: String?,
    tint: Color = .primary,
    isUserInteractionEnabled: Bool = true,
    timing: ToastTime = .medium
  ) {
    Task { @MainActor in
      withAnimation(
        .snappy
      ) {
        toasts.append(
          .init(
            title: title,
            symbol: symbol,
            tint: tint,
            isUserInteractionEnabled: isUserInteractionEnabled,
            timing: timing
          )
        )
      }
    }
  }
  
  func present(
    title: String,
    symbolType: ToastSymbol
  ) {
    Task { @MainActor in
      withAnimation(
        .snappy
      ) {
        toasts.append(
          .init(
            title: title,
            symbol: symbolType.rawValue,
            tint: .primary,
            isUserInteractionEnabled: true,
            timing: .medium
          )
        )
      }
    }
  }
}

extension Toast {
  
  func presentCommonError() {
    present(title: .commonError, symbol: "xmark")
  }
}


enum ToastSymbol: String, CaseIterable {
  case xMark     = "xmark"
  case checkmark = "checkmark.circle.fill"
  case info      = "info.circle"
}


struct ToastItem: Identifiable {
  let id: UUID = .init()
  var title: String
  var symbol: String?
  var tint: Color
  var isUserInteractionEnabled: Bool
  
  var timing: ToastTime = .medium
}

enum ToastTime: CGFloat {
  case short = 1.0
  case medium = 3.0
  case long = 5.0
}

fileprivate struct ToastGroup: View {
  
  @StateObject var model = Toast.shared
  
  var body: some View {
    GeometryReader {
      let size = $0.size
      let safeArea = $0.safeAreaInsets
      
      ZStack {

        ForEach(model.toasts) { toast in
          ToastView(size: size, item: toast)
            .scaleEffect(scale(toast))
            .offset(y: offsetY(toast))
            .zIndex(Double(model.toasts.firstIndex(where: { $0.id == toast.id }) ?? 0))
        }
      }
      .padding(.bottom, safeArea.top == .zero ? 15: 10)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
  }
  
  /**
    새로운 Toast가 추가될 때 이전 index의 Toast의 offset 위로 10 옮겨간다.
   최대 2개의 Toast에 한해서만 해당 동작이 진행되며, 이후에 추가되는 Toast의 offset Y 는 20이 최대이다.
   */
  
  func offsetY(_ item: ToastItem) -> CGFloat {
    let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id}) ?? 0)
    let totalCount = CGFloat(model.toasts.count) - 1
    return (totalCount - index) >= 2 ? -20 : ((totalCount - index) * -10)
  }
  
  func scale(_ item: ToastItem) -> CGFloat {
    let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id}) ?? 0)
    let totalCount = CGFloat(model.toasts.count) - 1
    return 1.0 - ((totalCount - index) >= 2 ? 0.2 : ((totalCount - index) * 0.1))
  }
}

fileprivate struct ToastView: View {
  
  var size: CGSize
  var item: ToastItem
  
  @State private var delayTask: DispatchWorkItem?
  
  var body: some View {
    HStack(spacing: 0) {
      if let symbol = item.symbol {
        Image(systemName: symbol)
          .font(.title3)
          .padding(.trailing, 10)
      }
      
      Text(item.title)
        .font(.system(size: 12, weight: .semibold))
        .lineLimit(1)
    }
    .foregroundStyle(item.tint)
    .padding(.horizontal, 15)
    .padding(.vertical, 8)
    .background(
      .background
        .shadow(.drop(color: .primary.opacity(0.06), radius: 5, x: 5, y: 5))
        .shadow(.drop(color: .primary.opacity(0.06), radius: 8, x: -5, y: -5)),
      in: .capsule
    )
    .contentShape(.capsule)
    .gesture(
      DragGesture(minimumDistance: 0)
        .onEnded { value in
          guard item.isUserInteractionEnabled else { return }
          let endY = value.translation.height
          let velocityY = value.velocity.height
          
          if (endY + velocityY) > 100 {
            removeToast()
          }
        }
    )
    .onAppear {
      guard delayTask == nil else { return }
      
      delayTask = .init(block: {
        removeToast()
      })
      
      if let delayTask {
        DispatchQueue.main.asyncAfter(deadline: .now() + item.timing.rawValue, execute: delayTask)
      }
    }
    .frame(maxWidth: size.width * 0.7)
    .transition(.offset(y: 150))
  }

  
  func removeToast() {
    if let delayTask {
      delayTask.cancel()
    }
    withAnimation(.snappy) {
      Toast.shared.toasts.removeAll(where: { $0.id == item.id })
    }
  }
}
