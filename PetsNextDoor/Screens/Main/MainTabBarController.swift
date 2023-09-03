//
//  MainTabBarController.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/27.
//

import UIKit
import SnapKit

final class MainTabBarController: UITabBarController {
  
  private let homeNavigationController       = BaseNavigationController(rootViewController: HomeViewController())
  private let discoverNavigationController   = BaseNavigationController(rootViewController: DiscoverViewController())
  private let chatListNavigationController   = BaseNavigationController(rootViewController: ChatListViewController())
  private let myPageNavigationController     = BaseNavigationController(rootViewController: MyPageViewController())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let appearance = tabBar.standardAppearance
    appearance.configureWithOpaqueBackground()
    appearance.shadowImage = nil
    appearance.shadowColor = nil
    tabBar.standardAppearance = appearance
    
    
    configureViewControllers()

  }
  
  
  private func configureViewControllers() {
    
    setViewControllers(
      [
        homeNavigationController,
        discoverNavigationController,
        chatListNavigationController,
        myPageNavigationController
      ]
      ,
      animated: true)
  }
  

  
}
