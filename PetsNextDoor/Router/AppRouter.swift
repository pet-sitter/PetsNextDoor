//
//  AppRouter.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import UIKit
import Combine
import ComposableArchitecture

final class AppRouter {

  static let shared = AppRouter()

  private let store: StoreOf<Router<PND.Destination>>
  private let viewStore: ViewStoreOf<Router<PND.Destination>>

  private init() {
    self.store = StoreOf<Router<PND.Destination>>(initialState: Router.State(), reducer: Router())
    self.viewStore = ViewStore(store, observe: { $0 } )
  }
  
  
  func receive(_ action: Router<PND.Destination>.Action) {
    viewStore.send(action)
  }


}

