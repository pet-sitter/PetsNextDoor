//
//  SceneDelegate.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/06/17.
//

import UIKit
import FirebaseCore
import ComposableArchitecture
import IQKeyboardManagerSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    self.window?.windowScene = windowScene
    
    guard let window else { return }
    
    FirebaseApp.configure()
    
    IQKeyboardManager.shared.enable = true
    
  
    AppAppearanceManager.shared.configureInitialAppearance()
  
    // 로그인 체크하고 분기 처리해야함
    
    
    let loginVC = LoginViewController(
      store: .init(
        initialState: LoginFeature.State(),
        reducer: { LoginFeature()}
      )
    )

    let navController = BaseNavigationController(rootViewController: loginVC)
    
//    let mainTabVC = MainTabBarController(
//      homeStore: .init(initialState: .init(), reducer: HomeFeature()),
//      communityStore: .init(initialState: .init(), reducer: CommunityFeature()),
//      chatListStore: .init(initialState: .init(), reducer: ChatListFeature()),
//      myPageStore: .init(initialState: .init(), reducer: MyPageFeature())
//    )
//    
//    let navController = BaseNavigationController(rootViewController: mainTabVC)
    
    window.rootViewController = navController
    window.overrideUserInterfaceStyle = .light
    window.makeKeyAndVisible()
    
    
    
    
    
  }

  
  
  func sceneDidDisconnect(_ scene: UIScene) {
    
  }

  func sceneDidBecomeActive(_ scene: UIScene) {

  }

  func sceneWillResignActive(_ scene: UIScene) {

  }

  func sceneWillEnterForeground(_ scene: UIScene) {

  }

  func sceneDidEnterBackground(_ scene: UIScene) {

  }
}

