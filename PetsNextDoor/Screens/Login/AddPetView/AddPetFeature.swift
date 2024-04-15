//
//  AddPetViewController.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/01.
//

import Foundation
import ComposableArchitecture

struct AddPetFeature: Reducer {
  
  struct State: Equatable {
    var selectedPetImageData: Data?
    var petName: String = ""
    var selectedGenderIndex: Int = 0
    var gender: PND.Sex = .male
    var isNeutralized: Bool = false
    let selectedPetType: PND.PetType
    
    var birthdayDate: Date = .init()
    var weight: Int?
    var isBottomButtonEnabled: Bool = false
    var petAge: Int?
   
    var birthday: String = "2024-01-01"
    
    var selectedBreedName: String? = nil
    
    var cautionText: String = ""
    
    @PresentationState var petSpeciesListState: PetSpeciesListFeature.State? = nil
    @PresentationState var addCautionsState: AddCautionsFeature.State? = nil
  }
  
  enum Action: Equatable {

    case onPetImageDataChange(Data?)
    case onPetNameChange(String?)
    case onPetGenderIndexChange(Int)
    case onIsNeutralizedCheckBoxTap(Bool)
    case onSelectPetSpeciesButtonTap
    case onPetBirthdayDateChange(Date)
    case onWeightChange(Int?)
    
    case didTapBottomButton
    case onPetAddComplete(AddPetFeature.State)
    
    case petSpeciesListAction(PresentationAction<PetSpeciesListFeature.Action>)
    case addCautionsAction(PresentationAction<AddCautionsFeature.Action>)
  }
  
  var body: some Reducer<State,Action> {
    Reduce { state, action in
      switch action {
        
      case .onPetImageDataChange(let data):
        state.selectedPetImageData = data
        return .none
        
      case .onPetNameChange(let text):
        guard let text else { return .none }
        if text.count >= 2 && text.count <= 20 {
          state.petName = text
          state.isBottomButtonEnabled = true
        } else {
          state.isBottomButtonEnabled = false
        }
        return .none
        
      case .onPetGenderIndexChange(let index):
        if index == 0 {
          state.gender = .male
        } else if index == 1 {
          state.gender = .female
        }
        return .none
        
      case .onIsNeutralizedCheckBoxTap(let isSelected):
        state.isNeutralized = isSelected
        return .none
        
      case .onSelectPetSpeciesButtonTap:
        state.petSpeciesListState = PetSpeciesListFeature.State(selectedPet: state.selectedPetType)
        return .none
        
      case .onPetBirthdayDateChange(let date):
        state.birthday      = DateConverter.convertDateToString(date: date)
        state.birthdayDate  = date
        return .none
        
      case .onWeightChange(let weight):
        state.weight = weight
        return .none
        
      case .didTapBottomButton:
        if state.cautionText.isEmpty  {
          state.addCautionsState = AddCautionsFeature.State()
          return .none
        } else if state.selectedBreedName == nil {
          let title = state.selectedPetType == .cat ? "묘종을 선택해주세요" : "견종을 선택해주세요"
          
          Toast.shared.present(
            title: title,
            symbol: nil
          )
          
          return .none
        }
        
        else {
          state.petAge      = DateConverter.calculateAge(state.birthday)
          return .send(.onPetAddComplete(state))
        }
        
      case .onPetAddComplete:
        return .none
        
      case let .petSpeciesListAction(.presented(.onBreedSelection(breedName))):
        state.selectedBreedName = breedName
        state.petSpeciesListState = nil
        return .none
        
      case .petSpeciesListAction(.presented(_:)):
        return .none

      case .petSpeciesListAction(.dismiss):
        state.petSpeciesListState = nil
        return .none
        
        // AddCautions.Action
        
      case .addCautionsAction(.presented(.onBottomButtonTap)):
        state.addCautionsState = nil
        return .none
        
      case .addCautionsAction(.presented(.onCautionTextChange(let text))):
        state.cautionText = text
        return .none
        
      case .addCautionsAction(.dismiss):
        state.addCautionsState = nil
        return .none
      }
    }
    .ifLet(\.$petSpeciesListState, action: /Action.petSpeciesListAction) {
      PetSpeciesListFeature()
    }
    .ifLet(\.$addCautionsState, action: /Action.addCautionsAction) {
      AddCautionsFeature()
    }
  }
}
