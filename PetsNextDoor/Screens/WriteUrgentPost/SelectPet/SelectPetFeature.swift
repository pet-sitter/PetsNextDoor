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
    
    
        state.isBottomButtonEnabled = state 
          .selectPetCellViewModels
          .filter(\.isPetSelected)
          .count > 0
        
        state.urgentPostModel.petIds = state
          .selectPetCellViewModels
          .filter(\.isPetSelected)
          .map(\.id)

      
        return .none
        
      case .setBottomButtonEnabled(let isEnabled):
        return .none
      }
    }
  }
}
