//
//  AppStore.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/16.
//

import Foundation

typealias AppStoreType = Store<AppReducer.State, AppReducer.Action, AppReducer.Feedback, AppReducer.Output>

final class AppStore: AppStoreType {
  
  static let shared = AppStore(
    initialState: AppReducer.State(),
    reducer: AppReducer(authenticationMiddleWare: AuthenticationMiddleWare())
  )
}
