//
//  LoadingIndicatorView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import UIKit
import SnapKit

final class LoadingIndicatorView: UIView {
  
  var activityIndicator: UIActivityIndicatorView!
  
  var isAnimating: Bool = false {
    didSet { isAnimating ? startAnimating() : stopAnimating() }
  }
  
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  deinit { stopAnimating() }
  
  private func configureUI() {
    
    self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    
    activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.color = UIColor(resource: R.color.mainColor)
    self.addSubview(activityIndicator)
    
    activityIndicator.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(CGSize(width: 50, height: 50))
    }
  }
  
  func startAnimating() {
    Task { @MainActor in
      guard let window = UIApplication.findKeyWindow() else { return }
      
      if let _ = window.subviews.first(where: { $0 is Self }) as? Self {
        return
      } else {
        self.frame = window.frame
        window.addSubview(self)
      }
      
      activityIndicator.startAnimating()
    }
  }
  
  func stopAnimating() {
    Task { @MainActor in
      guard let window = UIApplication.findKeyWindow() else { return }
      
      window
        .subviews
        .filter { $0 is Self }
        .forEach {
          ($0 as? Self)?.activityIndicator.stopAnimating()
          $0.removeFromSuperview()
        }
    }
  }
}


