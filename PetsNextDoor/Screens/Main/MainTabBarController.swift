//
//  MainTabBarController.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/27.
//

import UIKit
import SnapKit

final class MainTabBarController: UITabBarController {
  
  private let homeVC      = BaseNavigationController(rootViewController: HomeViewController())
  private let discoverVC  = BaseNavigationController(rootViewController: DiscoverViewController())
  private let chatListVC  = BaseNavigationController(rootViewController: ChatListViewController())
  private let myPageVC    = BaseNavigationController(rootViewController: MyPageViewController())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    

  }
  
  

  
}
