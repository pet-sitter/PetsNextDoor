//
//  AppDelegate.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/06/17.
//
import SwiftUI

import ComposableArchitecture
import FirebaseCore
import GoogleSignIn
import IQKeyboardManagerSwift

@main
struct PNDRootApp: App {
  
  @StateObject private var router = Router()
  
  init() {
    FirebaseApp.configure()
    IQKeyboardManager.shared.enable = true
  }
  
  var body: some Scene {
    WindowGroup {
      RootView { loginView }
        .environmentObject(router)
    }
  }
  
  
  @ViewBuilder
  var loginView: some View {
    NavigationStack(path: $router.navigationPath) {
      LoginView(store: .init(
        initialState: .init(),
        reducer: { LoginFeature() }
      ))
    }
    .tint(.commonBlack)
    .environmentObject(router)
  }
}




struct PNDRootFeature: Reducer {
  
  
  struct State: Equatable {
    
  }
  
  enum Action: Equatable {
    
  }
  
  var body: some Reducer<State,Action> {
    Reduce { state, action in
      return .none
    }
  }
  

}




struct TabBarView: View {
  
  @EnvironmentObject var router: Router
  
  var body: some View {
    TabView {
      NavigationStack(path: $router.navigationPath) {
        HomeView(store: .init(
          initialState: HomeFeature.State(),
          reducer: { HomeFeature() }
        ))
      }
      .environmentObject(router)
      .tabItem {
        VStack {
          Image("icon_home")
        }
      }
      
      CommunityView(store: .init(
        initialState: CommunityFeature.State(),
        reducer: {CommunityFeature()}
      ))
      .tabItem {
        VStack {
          Image("icon_community")
        }
      }
      
      ChatListView(store: .init(
        initialState: .init(),
        reducer: { ChatListFeature() }
      ))
      .tabItem {
        VStack {
          Image("icon_chat")
        }
      }
      
      MyPageView(store: .init(
        initialState: .init(),
        reducer: { MyPageFeature()}
      ))
      .tabItem {
        VStack {
          Image("icon_user")
        }
      }
      
      
    }
  }
}



//@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return true
  }

  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(
    _ application: UIApplication,
    didDiscardSceneSessions sceneSessions: Set<UISceneSession>
  ) {

  }
}

extension AppDelegate {
  
  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    return GIDSignIn.sharedInstance.handle(url)
  }
}
