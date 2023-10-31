//
//  AppAppearanceManager.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/20.
//

import UIKit

struct AppAppearanceManager {
  
  static let shared = AppAppearanceManager()
  
  private init() {}
  
  func configureInitialAppearance() {
    UINavigationBar.appearance().tintColor = PND.Colors.commonBlack
  }
}
