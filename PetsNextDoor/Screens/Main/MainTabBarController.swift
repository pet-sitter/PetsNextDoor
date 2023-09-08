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
  private let communityNavigationController   = BaseNavigationController(rootViewController: CommunityViewController())
  private let chatListNavigationController   = BaseNavigationController(rootViewController: ChatListViewController())
  private let myPageNavigationController     = BaseNavigationController(rootViewController: MyPageViewController())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let appearance = tabBar.standardAppearance
    appearance.configureWithOpaqueBackground()
    appearance.shadowImage = nil
    appearance.shadowColor = nil
    tabBar.standardAppearance = appearance
    
    
    homeNavigationController.tabBarItem.image         = UIImage(named: "icon_home")?.withRenderingMode(.alwaysOriginal)
    homeNavigationController.tabBarItem.selectedImage = UIImage(named: "icon_home_selected")?.withRenderingMode(.alwaysOriginal)
    
    communityNavigationController.tabBarItem.image          = UIImage(named: "icon_community")?.withRenderingMode(.alwaysOriginal)
    communityNavigationController.tabBarItem.selectedImage  = UIImage(named: "icon_community_selected")?.withRenderingMode(.alwaysOriginal)
    
    chatListNavigationController.tabBarItem.image = UIImage(named: "icon_chat")?.withRenderingMode(.alwaysOriginal)
    
    myPageNavigationController.tabBarItem.image = UIImage(named: "icon_user")?.withRenderingMode(.alwaysOriginal)
    
    
    
    configureViewControllers()
  }
  
  
  private func configureViewControllers() {
    
    setViewControllers(
      [
        homeNavigationController,
        communityNavigationController,
        chatListNavigationController,
        myPageNavigationController
      ]
      ,
      animated: true)
  }
  

  
}
