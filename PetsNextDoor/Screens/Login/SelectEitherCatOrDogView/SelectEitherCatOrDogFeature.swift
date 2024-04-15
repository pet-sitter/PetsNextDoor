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

@Reducer
struct AddPetPath {
  
  @ObservableState
  enum State: Equatable {
    case addPet(AddPetFeature.State)
  }
  
  enum Action: Equatable {
    case addPet(AddPetFeature.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.addPet, action: \.addPet) { AddPetFeature() }
  }
}

@Reducer
struct SelectEitherCatOrDogFeature: Reducer {
  
  @Dependency(\.dismiss) var dismiss
	
  @ObservableState
	struct State: Equatable {
		var isBottomButtonEnabled: Bool = false
		var selectedPetType: PND.PetType? = nil
    
    var path: StackState<AddPetPath.State> = .init()
	}
	
	enum Action: RestrictiveAction, BindableAction {
    
    enum ViewAction: Equatable {
      case viewDidAppear
      case onPetSelection(PND.PetType)
      case didTapBottomButton
      case onDismiss
    }
    
    enum DelegateAction: Equatable {
      
      case moveToAddPetView
      case dismissComplete
      case onPetAddComplete(AddPetFeature.State)
    }
    
    enum InternalAction: Equatable {

    }
    
    case view(ViewAction)
    case delegate(DelegateAction)
    case `internal`(InternalAction)
    
    case binding(BindingAction<State>)
    case path(StackAction<AddPetPath.State, AddPetPath.Action>)
	}
	
	var body: some Reducer<State, Action> {
    
    BindingReducer()
    
    addPetReducer
    
		Reduce { state, action in
			switch action {
      
      case .view(.viewDidAppear):
        return .none

      case .view(.onPetSelection(let petType)):
				state.selectedPetType = petType
				state.isBottomButtonEnabled = true
				return .none
				
      case .view(.didTapBottomButton):
        guard let petType = state.selectedPetType else { return .none }
        return .send(.delegate(.moveToAddPetView))
        
      case .view(.onDismiss):
        return .send(.delegate(.dismissComplete))
        
      case .delegate(_):
        return .none
      case .binding(_):
        return .none
      case .path(_):
        return .none
      }
		}
	}
  
  var addPetReducer: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case let .path(action):
        switch action {
        case .element(id: _, action: .addPet(.onPetAddComplete(let addPetState))):
          return .run { send in
//            await dismiss(animation: .default)
            await send(.delegate(.onPetAddComplete(addPetState)))
          }
          
        default:
          return .none
        }
        
      case .delegate(.moveToAddPetView):
        guard let petType = state.selectedPetType else { return .none }
        
        state.path.append(.addPet(AddPetFeature.State(selectedPetType: petType )))
        return .none
        
      default:
        return .none
      }
    }
    .forEach(\.path, action: /Action.path) {
      AddPetPath()
    }
  }
}
