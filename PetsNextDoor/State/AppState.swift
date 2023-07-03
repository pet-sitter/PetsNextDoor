//
//  AppState.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/03.
//

import Foundation

struct AppState: Codable {
  
  let screens: [AppScreenState]
  
  init(screens: [AppScreenState]) {
    self.screens = screens
  }
  
  static let reducer: Reducer<Self> = { state, action in
    
    var screens = state.screens
    
    switch action {
    
    default: break
    }
    
    
    screens = screens.map { AppScreenState.reducer($0, action) }
    return AppState(screens: screens)
  }
}


extension AppState {
  
  func screenState<State>(forScreen screen: AppScreen) -> State? {
      return nil
//    let topState = screens
//      .compactMap {
//        switch ($0, screen) {
//        case (.login, screen)
//        }
//      }
//      .first
//
//    return topState
  }
}


extension AppState {
  
  enum AppStateAction: Action {
    case showScreen(AppScreen)
    case dismiss(AppScreen)
  }
}
