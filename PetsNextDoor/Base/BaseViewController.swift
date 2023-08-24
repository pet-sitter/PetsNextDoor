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
  
  var subscriptions = Set<AnyCancellable>()
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable) required init?(coder: NSCoder) { fatalError("Not implemented") }
  
  deinit { print("✅ DEINIT: \(String(describing: Self.self))")}
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  func configureUI() {
		view.backgroundColor = PND.Colors.commonWhite
  }
  
  func configureTopLeftTitle(_ title: String) {
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: nil)
  }
}
