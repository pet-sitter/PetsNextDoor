//
//  CommonRedux.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/03.
//

import Foundation

class ReduxContainer {
  static let store = Store(
    initialState: AppState(activeScreens: []),
    reducer: AppState.reducer,
    middleWares: [.printer: MiddleWares.printer]
  )
}
