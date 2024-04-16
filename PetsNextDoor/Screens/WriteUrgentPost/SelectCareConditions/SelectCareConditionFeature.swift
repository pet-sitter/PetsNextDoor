//
//  SelectCareConditionFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/07.
//

import Foundation
import ComposableArchitecture

struct SelectCareConditionFeature: Reducer {
  
  struct State: Hashable {
    // 성별
    var selectedGenderIndex: Int = 0

    // 돌봄 형태
    var selectedCareTypeIndex: Int = 0
    var careType: PND.CareType      = .visiting
 
    // 페이
    var rewardType: PND.RewardType = .pay
    var rewardAmount: String = ""
    var rewardOptionPrompt: String = PND.RewardType.pay.prompt
    
    // 날짜
    var selectedDates: Set<DateComponents> = []
    var selectedDatesText: String = "아래에서 날짜를 선택하세요."
    
    
    // 그 외

    var urgentPostModel: PND.UrgentPostModel
    var isBottomButtonEnabled: Bool = true
    var isPayTextFieldDisabled: Bool = false
    var onlyAllowNumberInput: Bool = true
    
  }
  
  enum Action: Equatable {
    case viewDidLoad
    
    case onGenderIndexChange(Int)
    case onCareTypeIndexChange(Int)

    case onRewardTypeChange(PND.RewardType)
    case onRewardAmountChange(String)

    case onSelectedDatesChanged(Set<DateComponents>)
    
    case setBottomButtonEnabled(Bool)
    case onBottomButtonTap
    
    case pushToSelectOtherRequirementsView(PND.UrgentPostModel)
    
  }
  

  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .viewDidLoad:
        return .none
   
      case .onGenderIndexChange(let index):
        state.selectedGenderIndex = index
        switch index {
        case 0:
          state.urgentPostModel.carerGender = .male
        case 1:
          state.urgentPostModel.carerGender = .female
        case 2:
          state.urgentPostModel.carerGender = .all
        default: ()
        }
        return .none
        
      case .onCareTypeIndexChange(let index):
        state.selectedCareTypeIndex = index
        switch index {
        case 0:
          state.urgentPostModel.careType = .visiting  // 방문 돌봄
        case 1:
          state.urgentPostModel.careType = .foster    // 위탁돌봄
        default: ()
        }
        return .none
        
      case .onRewardTypeChange(let rewardType):
        state.rewardAmount       = ""
        state.rewardType         = rewardType
        state.rewardOptionPrompt = rewardType.prompt
        
        state.isPayTextFieldDisabled = false
        if rewardType == .negotiable {
          state.isPayTextFieldDisabled = true
        }
        
        if rewardType == .pay {
          state.onlyAllowNumberInput = true
        } else {
          state.onlyAllowNumberInput = false
        }
        
        state.urgentPostModel.rewardType = rewardType
        return .none
        
      case .onRewardAmountChange(let rewardAmount):
        state.rewardAmount            = rewardAmount
        state.urgentPostModel.reward  = rewardAmount
        return .none
        
      case .onSelectedDatesChanged(let dateComponents):
        guard dateComponents.isEmpty == false else {
          state.selectedDatesText = "아래에서 날짜를 선택하세요."
          return .none
        }
        
        state.selectedDates  = dateComponents
        
        let selectedDateText = dateComponents
          .compactMap(\.day)
          .sorted()
          .map { String($0) }
          .joined(separator: ",")
        
        state.selectedDatesText     = "\(selectedDateText)일"
        state.urgentPostModel.dates = DateConverter.convertDateComponentsToPNDDateModel(dateComponents)
        return .none
        
      case .setBottomButtonEnabled(let isEnabled):
        state.isBottomButtonEnabled = isEnabled
        return .none
        
      case .onBottomButtonTap:
        return .send(.pushToSelectOtherRequirementsView(state.urgentPostModel))
        
      case .pushToSelectOtherRequirementsView:
        return .none
      }
    }
  }
}
