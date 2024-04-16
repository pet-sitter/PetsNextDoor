//
//  SelectPetListFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/30.
//

import Foundation
import ComposableArchitecture

struct SelectPetListFeature: Reducer {
  
  @Dependency(\.petService) var petService
  
  struct State: Equatable, Hashable {
    var selectPetCellViewModels: [SelectPetViewModel] = []
    var selectedPets: [SelectPetViewModel] = []
    var isBottomButtonEnabled: Bool = false
    
    var urgentPostModel: PND.UrgentPostModel = .empty()
  }
  
  enum Action: Equatable {
    case viewDidLoad
    case didSelectPet(SelectPetViewModel)
    case setMyPets([PND.Pet])
    case setBottomButtonEnabled(Bool)
    case onBottomButtonTap
    
    case pushToSelectCareConditionsView(PND.UrgentPostModel)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .viewDidLoad:
        return .run { send in
          
          let myPets = try await petService.getMyPets().pets
          
          await send(.setMyPets(myPets))
          
        } catch: { error, send in
          Toast.shared.present(title: .commonError, symbol: "xmark")
          await send(.setMyPets([]))
        }
        
      case .setMyPets(let petModel):
        
        if petModel.isEmpty { // 테스트용 코드
          state.selectPetCellViewModels = MockDataProvider.selectPetCellViewModels
          return .none
        }
        
        state.selectPetCellViewModels = petModel.map {
          SelectPetViewModel(
            id: $0.id,
            petImageUrlString: $0.profileImageUrl,
            petName: $0.name,
            petSpecies: $0.breed,
            petAge: DateConverter.calculateAge($0.birthDate),
            gender: $0.sex,
            petType: $0.petType,
            birthday: $0.birthDate,
            weight: $0.weightInKg
          )
        }
        
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
        state.isBottomButtonEnabled = isEnabled
        return .none
        
      case .onBottomButtonTap:
        return .send(.pushToSelectCareConditionsView(state.urgentPostModel))
      
      case .pushToSelectCareConditionsView:
        return .none
      }
    }
  }
}
