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
    case eventDetail(EventDetailFeature.State)
    case urgentPostDetail(UrgentPostDetailFeature.State)
    case selectPetList(SelectPetListFeature.State)
    case selectCareConditions(SelectCareConditionFeature.State)
    case selectOtherRequirements(SelectOtherRequirementsFeature.State)
    case chat(ChatFeature.State)
    case chatMemberList(ChatMembersFeature.State)
    case writeUrgentPost(WriteUrgentPostFeature.State)
		case myActivity(MyActivityFeature.State)
    case settings(SettingsFeature.State)
  }
  
  enum Action {
    case eventDetail(EventDetailFeature.Action)
    case urgentPostDetail(UrgentPostDetailFeature.Action)
    case selectPetList(SelectPetListFeature.Action)
    case selectCareConditions(SelectCareConditionFeature.Action)
    case selectOtherRequirements(SelectOtherRequirementsFeature.Action)
    case chat(ChatFeature.Action)
    case chatMemberList(ChatMembersFeature.Action)
    case writeUrgentPost(WriteUrgentPostFeature.Action)
		case myActivity(MyActivityFeature.Action)
    case settings(SettingsFeature.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.eventDetail, action: \.eventDetail) { EventDetailFeature() }
    Scope(state: \.urgentPostDetail, action: \.urgentPostDetail) { UrgentPostDetailFeature() }
    Scope(state: \.selectPetList, action: \.selectPetList) { SelectPetListFeature() }
    Scope(state: \.selectCareConditions, action: \.selectCareConditions) { SelectCareConditionFeature() }
    Scope(state: \.selectOtherRequirements, action: \.selectOtherRequirements) { SelectOtherRequirementsFeature() }
    Scope(state: \.chat, action: \.chat) { ChatFeature() }
    Scope(state: \.chatMemberList, action: \.chatMemberList) { ChatMembersFeature() }
    Scope(state: \.writeUrgentPost, action: \.writeUrgentPost) { WriteUrgentPostFeature() }
    Scope(state: \.myActivity, action: \.myActivity) { MyActivityFeature() }
    Scope(state: \.settings, action: \.settings) { SettingsFeature() }
  }
}
