//
//  File.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import UIKit

final class RootViewController: BaseViewController {
  
  typealias StoreType = Store<RootViewReducer.State, RootViewReducer.Action, RootViewReducer.Feedback, RootViewReducer.Output>
  
  var mainTabBarController: UITabBarController?
  var mainNavigationController: UINavigationController?
  
  private let store: StoreType
  private let router: Routable
  
  init(store: StoreType, router: Routable) {
    self.store  = store
    self.router = router
    super.init()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
