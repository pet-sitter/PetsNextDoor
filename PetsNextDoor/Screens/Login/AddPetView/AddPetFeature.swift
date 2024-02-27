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
    var otherInfo: String = ""
    var isBottomButtonEnabled: Bool = false
    var petAge: Int?
   
    var birthday: String = "2024-01-01"
    
    var selectedBreedName: String? = nil
    
    @PresentationState var petSpeciesListState: PetSpeciesListFeature.State? = nil
  }
  
  enum Action: Equatable {

    case onPetImageDataChange(Data?)
    case onPetNameChange(String?)
    case onPetGenderIndexChange(Int)
    case onIsNeutralizedCheckBoxTap(Bool)
    case onSelectPetSpeciesButtonTap
    case onPetBirthdayDateChange(Date)
    case onWeightChange(Int?)
    case onOtherInfoChange(String)
    
    case didTapBottomButton
    case onPetAddition
    
    case petSpeciesListAction(PresentationAction<PetSpeciesListFeature.Action>)
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
        state.petSpeciesListState = .init()
        return .none
        
      case .onPetBirthdayDateChange(let date):
        state.birthday = DateConverter.convertDateToString(date: date)
        state.birthdayDate = date
        return .none
        
      case .onWeightChange(let weight):
        state.weight = weight
        return .none
        
      case .onOtherInfoChange(let otherInfoString):
        state.otherInfo = otherInfoString
        return .none
        
      case .didTapBottomButton:
        if state.selectedBreedName == nil {
          Toast.shared.present(title: "묘종을 입력하세요", symbol: nil)
          return .none
        }
        state.petAge      = 2
        return .send(.onPetAddition)
        
      case .onPetAddition:
        return .none
        
      case let .petSpeciesListAction(.presented(.onSelectedBreedChange(breed))):
        state.selectedBreedName = breed.name
        state.petSpeciesListState = nil
        return .none
        
      case .petSpeciesListAction(.dismiss):
        state.petSpeciesListState = nil
        return .none
        
      case .petSpeciesListAction(.presented(_:)):
        return .none

      }
    }
    .ifLet(\.$petSpeciesListState, action: /Action.petSpeciesListAction) {
      PetSpeciesListFeature()
    }
  }
}
