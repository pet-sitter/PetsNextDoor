//
//  File.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import UIKit

/**
 - 앱 최하단에 항상 깔려있는 ViewController
*/

final class RootViewController: BaseViewController {

  private(set) var mainNavigationController: UINavigationController?
  private(set) var mainTabBarController: UITabBarController?
  
  override init() {
    super.init()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func configureMainNavigationController(with navigationController: UINavigationController) {
    // child 가 uitabbarcontroller이거나 있으면 없애고 추가하기?
    addChild(navigationController)
    navigationController.didMove(toParent: self)
    view.addSubview(navigationController.view)
    navigationController.view.frame = view.frame
    navigationController.navigationBar.tintColor = PND.Colors.commonBlack
    navigationController.navigationBar.prefersLargeTitles = true
    self.mainNavigationController = navigationController
  }
  
  func configureMainTabBarController(with tabBarController: UITabBarController) {
    // child가 navcontroller이거나 있으면 없애고 추가하기?
  }
}
