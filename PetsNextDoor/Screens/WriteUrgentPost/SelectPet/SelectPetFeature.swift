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
        state.selectPetCellViewModels = [
          .init(
            petImageUrlString: "",
            petName: "아롱",
            petSpecies: "비숑 프리제",
            petAge: 1,
            isPetNeutralized: true,
            isPetSelected: false,
            isDeleteButtonHidden: true
          ),
          .init(
            petImageUrlString: "",
            petName: "비숑이",
            petSpecies: "쿼카",
            petAge: 2,
            isPetNeutralized: false,
            isPetSelected: false,
            isDeleteButtonHidden: true
          ),
          .init(
            petImageUrlString: "",
            petName: "시바견",
            petSpecies: "비숑",
            petAge: 12,
            isPetNeutralized: false,
            isPetSelected: false,
            isDeleteButtonHidden: true
          ),
          .init(
            petImageUrlString: "",
            petName: "키키",
            petSpecies: "말티즈",
            petAge: 5,
            isPetNeutralized: true,
            isPetSelected: false,
            isDeleteButtonHidden: true
          )
        ]
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
      
        return .none
        
      case .didTapBottomButton:
        return .send(._routeAction(.pushScreen(.selectCareCondition(state: .init()), animated: true)))
        
      default:
        return .none
      }
    }
  }
}