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
    case selectCareConditions(SelectCareConditionFeature.State)
    case selectOtherRequirements(SelectOtherRequirementsFeature.State)
    case writeUrgentPost(WriteUrgentPostFeature.State)
		case myActivity(MyActivityFeature.State)
  }
  
  enum Action {
    case urgentPostDetail(UrgentPostDetailFeature.Action)
    case selectPetList(SelectPetListFeature.Action)
    case selectCareConditions(SelectCareConditionFeature.Action)
    case selectOtherRequirements(SelectOtherRequirementsFeature.Action)
    case writeUrgentPost(WriteUrgentPostFeature.Action)
		case myActivity(MyActivityFeature.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.urgentPostDetail, action: \.urgentPostDetail) { UrgentPostDetailFeature() }
    Scope(state: \.selectPetList, action: \.selectPetList) { SelectPetListFeature() }
    Scope(state: \.selectCareConditions, action: \.selectCareConditions) { SelectCareConditionFeature() }
    Scope(state: \.selectOtherRequirements, action: \.selectOtherRequirements) { SelectOtherRequirementsFeature() }
    Scope(state: \.writeUrgentPost, action: \.writeUrgentPost) { WriteUrgentPostFeature() }
		Scope(state: \.myActivity, action: \.myActivity) { MyActivityFeature() }
  }
}
