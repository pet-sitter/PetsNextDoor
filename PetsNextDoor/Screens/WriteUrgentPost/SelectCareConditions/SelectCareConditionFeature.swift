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
          state.urgentPostModel.carerGender = .male
        case 1:
          state.urgentPostModel.carerGender = .female
        case 2:
          state.urgentPostModel.carerGender = .female // 상관없음이 추가되어야 함
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
        
      case .onDateChange(let date):
        state.date = date
//        state.urgentPostModel.da
        return .none
        
      case .onPayAmountChange(let payAmount):
        guard let payAmount else { return .none }
        state.payAmount = payAmount
        state.urgentPostModel.reward = String(payAmount)
        return .none
        
      case .setBottomButtonEnabled(let isEnabled):
        state.isBottomButtonEnabled = isEnabled
        return .none
      }
    }
  }
}
