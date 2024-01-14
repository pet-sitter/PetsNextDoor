//
//  SelectPetFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/30.
//

import Foundation
import ComposableArchitecture

struct SelectPetFeature: Reducer {
  
  struct State: Equatable {
    var selectPetCellViewModels: [SelectPetViewModel] = []
    var selectedPets: [SelectPetViewModel] = []
    var isBottomButtonEnabled: Bool = false
    
    var urgentPostModel: PND.UrgentPostModel = .default()
    
    fileprivate var router: Router<PND.Destination>.State = .init()
  }
  
  enum Action: Equatable {
    case viewDidLoad
    case didSelectPet(SelectPetViewModel)
    case didTapBottomButton
    
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
        
      case .didTapBottomButton:
        let selectCareConditionState = SelectCareConditionFeature.State(
          urgentPostModel: state.urgentPostModel
        )
        return .send(._routeAction(.pushScreen(.selectCareCondition(state: selectCareConditionState), animated: true)))
        
      default:
        return .none
      }
    }
  }
}
