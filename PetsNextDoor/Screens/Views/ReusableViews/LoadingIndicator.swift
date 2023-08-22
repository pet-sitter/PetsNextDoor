//
//  LoadingIndicator.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import UIKit

final class LoadingIndicator {
  
  static func startAnimating() {
    Task { @MainActor in
      guard let window = UIApplication.findKeyWindow() else { return }
      
      let loadingIndicatorView: LoadingIndicatorView
      
      if let existingLoadingView = window.subviews.first(where: { $0 is LoadingIndicatorView }) as? LoadingIndicatorView {
        loadingIndicatorView = existingLoadingView
      } else {
        loadingIndicatorView = LoadingIndicatorView()
        loadingIndicatorView.frame = window.frame
        window.addSubview(loadingIndicatorView)
      }
      
      loadingIndicatorView.activityIndicator.startAnimating()
    }
  }
  
  static func stopAnimating() {
    Task { @MainActor in
      guard let window = UIApplication.findKeyWindow() else { return }
      
      window
        .subviews
        .filter { $0 is LoadingIndicatorView }
        .forEach {
          ($0 as? LoadingIndicatorView)?.activityIndicator.stopAnimating()
          $0.removeFromSuperview()
        }
    }
  }
}
