//
//  BaseViewController.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/07/04.
//

import UIKit
import Combine

class BaseViewController: UIViewController, LoadingIndicatorInsertable {
  
  var loadingIndicator: LoadingIndicatorView = .init()
  
//  var subscriptions = Set<AnyCancellable>()
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
//  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  @available(*, unavailable) required init?(coder: NSCoder) { fatalError("Not implemented") }
  
  deinit { print("✅ DEINIT: \(String(describing: Self.self))")}
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
  }
}
