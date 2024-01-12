//
//  SelectCareConditionFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/07.
//

import Foundation
import ComposableArchitecture

struct SelectCareConditionFeature: Reducer {
  
  struct State: Equatable {
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

    let selectedPetIds: [Int]
    var isBottomButtonEnabled: Bool = true
    var router: Router<PND.Destination>.State = .init()
  }
  
  enum Action: Equatable {
    case viewDidLoad
    case didTapBottomButton
    
    case onGenderIndexChange(Int)
    case onCareTypeIndexChange(Int)
    case onDateChange(Date)
    case onPayAmountChange(Int?)
    
    case setBottomButtonEnabled(Bool)
    
    // Internal Cases
    case _routeAction(Router<PND.Destination>.Action)

  }
  
  var body: some Reducer<State, Action> {
    
    Scope(
      state: \.router,
      action: /Action._routeAction
    ) {
      Router<PND.Destination>()
    }
    
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
        return .send(._routeAction(.pushScreen(.selectOtherRequirements(state: .init()), animated: true)))
        
      default:
        return .none
      }
    }
  }
}
