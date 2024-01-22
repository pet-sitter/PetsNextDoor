//
//  AppDelegate.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/06/17.
//

import UIKit
import GoogleSignIn
import SwiftUI
import ComposableArchitecture

@main
struct PNDApp: App {
  var body: some Scene {
    WindowGroup {
      TabView {
        HomeView(store: .init(
          initialState: HomeFeature.State(),
          reducer: {HomeFeature()}
        ))
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
  
  //MARK: - Paths
  
  struct Path: Reducer {
    
    enum State: Equatable {
      
      
    }
    
    enum Action: Equatable {
      
    }
    
    var body: some Reducer<State,Action> {
      Reduce { state, action in
        return .none
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
