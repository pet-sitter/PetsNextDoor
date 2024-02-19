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
  @State var index: Int = 0
  
  private let imageSize: CGFloat = 32
  
  var body: some View {
    TabView(selection: $index) {
      NavigationStack(path: $router.navigationPath) {
        HomeView(store: .init(
          initialState: HomeFeature.State(),
          reducer: { HomeFeature() }
        ))
      }
      .environmentObject(router)
      .tabItem {
        Image(index == 0 ? R.image.icon_home_selected : R.image.icon_home)
          .resizable()
          .frame(width: imageSize, height: imageSize)
      }
      .tag(0)
      
      CommunityView(store: .init(
        initialState: CommunityFeature.State(),
        reducer: {CommunityFeature()}
      ))
      .tabItem {
        Image(index == 1 ? R.image.icon_community_selected : R.image.icon_community)
          .resizable()
          .frame(width: imageSize, height: imageSize)
      }
      .tag(1)
      
      ChatListView(store: .init(
        initialState: .init(),
        reducer: { ChatListFeature() }
      ))
      .tabItem {
        Image(index == 2 ? R.image.icon_chat_selected : R.image.icon_chat)
          .resizable()
          .frame(width: imageSize, height: imageSize)
      }
      .tag(2)
      
      ScheduleView()
        .tabItem {
          Image(index == 3 ? R.image.icon_calendar_selected : R.image.icon_calendar)
            .resizable()
            .frame(width: imageSize, height: imageSize)
        }
        .tag(3)
      
      MyPageView(store: .init(
        initialState: .init(),
        reducer: { MyPageFeature()}
      ))
      .tabItem {
        Image(index == 4 ? R.image.icon_user_selected : R.image.icon_user)
          .resizable()
          .frame(width: imageSize, height: imageSize)
      }
      .tag(4)
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
