//
//  MainTabNavigationPath.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/04/11.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MainTabNavigationPath {
  
  @ObservableState
  enum State: Equatable {
    case urgentPostDetail(UrgentPostDetailFeature.State)
    case selectPetList(SelectPetListFeature.State)
  }
  
  enum Action {
    case urgentPostDetail(UrgentPostDetailFeature.Action)
    case selectPetList(SelectPetListFeature.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.urgentPostDetail, action: \.urgentPostDetail) { UrgentPostDetailFeature() }
    Scope(state: \.selectPetList, action: \.selectPetList) { SelectPetListFeature() }
  }
}
