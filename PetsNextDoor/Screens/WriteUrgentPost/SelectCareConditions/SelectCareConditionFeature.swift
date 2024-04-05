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
    var payOption: PayOption = .pay
    var payAmount: String = ""
    var payOptionPrompt: String = PayOption.pay.prompt
    
    // 날짜
    var date: Date = .init()
    var selectedDates: Set<DateComponents> = []
    
    
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

    case onPayOptionChange(PayOption)
    case onPayAmountChange(String)

    case onDateChange(Date)
    case onSelectedDatesChanged(Set<DateComponents>)
    
    case setBottomButtonEnabled(Bool)
    
  }
  
  enum PayOption: String, CaseIterable {
    case pay        = "사례비"
    case gifticon   = "기프티콘"
    case negotiable = "협의가능"
    
    var prompt: String {
      switch self {
      case .pay:        "원"
      case .gifticon:   "기프티콘 종류"
      case .negotiable: "협의가능"
      }
    }
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
        
      case .onDateChange(let date):
        state.date = date
//        state.urgentPostModel.da
        return .none
        
      case .onSelectedDatesChanged(let dateComponents):
        print("✅ date: \(dateComponents)")
        state.selectedDates = dateComponents
        return .none
        
      case .onPayOptionChange(let payOption):
        state.payAmount       = ""
        state.payOption       = payOption
        state.payOptionPrompt = payOption.prompt
        
        state.isPayTextFieldDisabled = false
        if payOption == .negotiable {
          state.isPayTextFieldDisabled = true
        }
        
        if payOption == .pay {
          state.onlyAllowNumberInput = true
        } else {
          state.onlyAllowNumberInput = false
        }
        
        return .none
        
      case .onPayAmountChange(let payAmount):
        state.payAmount = payAmount
//        state.urgentPostModel.reward = String(payAmount)
        return .none
        
      case .setBottomButtonEnabled(let isEnabled):
        state.isBottomButtonEnabled = isEnabled
        return .none
      }
    }
  }
}
