//
//  AppRouter.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import SwiftUI

final class Router: ObservableObject {
  
  typealias Destination = Hashable
  
  @Published var navigationPath: NavigationPath = .init()
  
  func pushScreen(to destination: any Destination) {
    navigationPath.append(destination)
  }
  
  func navigateBackToRoot() {
    navigationPath.removeLast(navigationPath.count)
  }
  
  func popScreen()  {
    navigationPath.removeLast()
  }
  
}

extension Router {
  
  static func changeRootViewToHomeView() {
    let window = UIApplication
      .shared
      .connectedScenes
      .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
      .first { $0.isKeyWindow }
    
    window?.rootViewController = UIHostingController(rootView: TabBarView().environmentObject(Router()))
    window?.makeKeyAndVisible()
    
    
  }
  
}
