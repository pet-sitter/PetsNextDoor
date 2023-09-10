//
//  MainTabBarController.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/27.
//

import UIKit
import SnapKit
import ComposableArchitecture

final class MainTabBarController: UITabBarController {

  private let homeNavigationController      : BaseNavigationController
  private let communityNavigationController : BaseNavigationController
  private let chatListNavigationController  : BaseNavigationController
  private let myPageNavigationController    : BaseNavigationController

  init(
    homeStore:      some StoreOf<HomeFeature>,
    communityStore: some StoreOf<CommunityFeature>,
    chatListStore:  some StoreOf<ChatListFeature>,
    myPageStore:    some StoreOf<MyPageFeature>
  ) {

    let homeVC      = HomeViewController(store: homeStore)
    let communityVC = CommunityViewController(store: communityStore)
    let chatVC      = ChatListViewController(store: chatListStore)
    let myPageVC    = MyPageViewController(store: myPageStore)
    
    homeNavigationController      = .init(rootViewController: homeVC)
    communityNavigationController = .init(rootViewController: communityVC)
    chatListNavigationController  = .init(rootViewController: chatVC)
    myPageNavigationController    = .init(rootViewController: myPageVC)
    super.init(nibName: nil, bundle: nil)
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
