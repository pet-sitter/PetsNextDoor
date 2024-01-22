//
//  SelectEitherCatOrDogViewController.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 11/26/23.
//

import UIKit
import Combine
import SnapKit
import ComposableArchitecture

struct SelectEitherCatOrDogFeature: Reducer {
	
	struct State: Equatable {
		var isBottomButtonEnabled: Bool = false
		var selectedPetType: PND.PetType? = nil

    var addPetState: AddPetFeature.State?
	}
	
	enum Action: Equatable, RestrictiveAction {
    
    enum ViewAction: Equatable {
      case viewDidAppear
      case onPetSelection(PND.PetType)
      case didTapBottomButton
      case onDismiss
    }
    
    enum DelegateAction: Equatable {
      case dismissComplete
      case onPetAddComplete(AddPetFeature.State)
    }
    
    enum InternalAction: Equatable {

    }
    
    case view(ViewAction)
    case delegate(DelegateAction)
    case `internal`(InternalAction)
    
    case _addPetAction(AddPetFeature.Action)
	}
	
	var body: some Reducer<State, Action> {
		Reduce { state, action in
			switch action {
      
      case .view(.viewDidAppear):
        state.addPetState = nil
        return .none

      case .view(.onPetSelection(let petType)):
				state.selectedPetType = petType
				state.isBottomButtonEnabled = true
				return .none
				
      case .view(.didTapBottomButton):
        guard let petType = state.selectedPetType else { return .none }
        state.addPetState = AddPetFeature.State(selectedPetType: petType)
        return .none
        
      case .view(.onDismiss):
        
        return .merge([
//          .send(._routeAction(.dismiss(completion: nil))),
          .send(.delegate(.dismissComplete))
        ])
        
        
      case ._addPetAction(.onPetAddition):
        if let addPetState = state.addPetState {
          return .send(.delegate(.onPetAddComplete(addPetState)))
        }
        return .none
        
				
			default: return .none
			}
		}
    .ifLet(
      \.addPetState,
       action: /Action._addPetAction
    ) {
      AddPetFeature()
    }
	}
}
