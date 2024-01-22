//
//  SelectPetFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/30.
//

import Foundation
import ComposableArchitecture

struct SelectPetFeature: Reducer {
  
  struct State: Equatable, Hashable {
    var selectPetCellViewModels: [SelectPetViewModel] = []
    var selectedPets: [SelectPetViewModel] = []
    var isBottomButtonEnabled: Bool = false
    
    var urgentPostModel: PND.UrgentPostModel = .default()
  }
  
  enum Action: Equatable {
    case viewDidLoad
    case didSelectPet(SelectPetViewModel)
    case didTapBottomButton
    
    case setBottomButtonEnabled(Bool)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .viewDidLoad:
        state.selectPetCellViewModels = MockDataProvider.selectPetCellViewModels
        return .none
        
      case .didSelectPet(let vm):
        vm.isPetSelected.toggle()
        
        state.selectedPets = state
          .selectPetCellViewModels
          .filter(\.isPetSelected)
      
        state.isBottomButtonEnabled = state 
          .selectPetCellViewModels
          .filter(\.isPetSelected)
          .count > 0
        
        state.urgentPostModel.petIds = state.selectedPets.map(\.id)
      
        return .none
        
      case .setBottomButtonEnabled(let isEnabled):
        
        return .none
        
      case .didTapBottomButton:
        let selectCareConditionState = SelectCareConditionFeature.State(
          urgentPostModel: state.urgentPostModel
        )
        return .none
        
      default:
        return .none
      }
    }
  }
}
