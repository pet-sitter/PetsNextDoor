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
    var carerGender: PND.GenderType = .female

    // 돌봄 형태
    var selectedCareTypeIndex: Int = 0
    var careType: PND.CareType      = .visiting
    
    // 날짜
    var date: Date = .init()
    
    // 페이
    var payAmount: Int? = nil 
    
    // 그 외

    var urgentPostModel: PND.UrgentPostModel
    var isBottomButtonEnabled: Bool = true
    
  }
  
  enum Action: Equatable {
    case viewDidLoad
    case didTapBottomButton
    
    case onGenderIndexChange(Int)
    case onCareTypeIndexChange(Int)
    case onDateChange(Date)
    case onPayAmountChange(Int?)
    
    case setBottomButtonEnabled(Bool)
    
    
    

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
          state.carerGender = .male
        case 1:
          state.carerGender = .female
        case 2:
          state.carerGender = .female       // 상관없음이 추가되어야 함
        default: ()
        }
        return .none
        
      case .onCareTypeIndexChange(let index):
        state.selectedCareTypeIndex = index
        switch index {
        case 0:
          state.careType = .visiting // 방문돌봄
        case 1:
          state.careType = .foster   // 위탁돌봄
        default: ()
        }
        return .none
        
      case .onDateChange(let date):
        state.date = date
        return .none
        
      case .onPayAmountChange(let payAmount):
        state.payAmount = payAmount
        return .none
        
      case .setBottomButtonEnabled(let isEnabled):
        state.isBottomButtonEnabled = isEnabled
        return .none
        
      case .didTapBottomButton:
        state.urgentPostModel.carerGender = state.carerGender
        state.urgentPostModel.careType = state.careType
        
        return .none
        // 날짜, 페이 세팅해야함 (default value 대체하기)
//        state.urgentPostModel.dateStartAt = ""
//        state.urgentPostModel.dateEndAt = ""
//        state.urgentPostModel.reward = ""
        
        
//        return .send(._routeAction(.pushScreen(.selectOtherRequirements(state: SelectOtherRequirementsFeature.State(urgentPostModel: state.urgentPostModel)), animated: true)))
        

      }
    }
  }
}
