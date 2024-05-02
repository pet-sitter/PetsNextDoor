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
    var isLoading: Bool = false
    var urgentPostModel: PND.UrgentPostModel = .empty()
  }
  
  enum Action: Equatable {
    case viewDidLoad
    case didSelectPet(SelectPetViewModel)
    case setMyPets([PND.Pet])
    case setBottomButtonEnabled(Bool)
    case onBottomButtonTap
    case setIsLoading(Bool)
    
    case pushToSelectCareConditionsView(PND.UrgentPostModel)
    case popToHomeView
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .viewDidLoad:
        guard state.selectPetCellViewModels.isEmpty else { return .none }
        
        return .run { send in
          
          await send(.setIsLoading(true))
          
          let myPets = try await petService.getMyPets().pets
          
          await send(.setMyPets(myPets))
          await send(.setIsLoading(false))
          
        } catch: { error, send in
          Toast.shared.present(title: .commonError, symbol: "xmark")
          await send(.setMyPets([]))
          await send(.setIsLoading(false ))
        }
        
      case .setMyPets(let petModel):
        
        if petModel.isEmpty {     // 반려동물 등록이 안 되어 있는데 혹시 들어오는 케이스 방지용
          Toast.shared.present(title: "반려동물 등록 후 사용 가능해요.", symbolType: .info)
          return .send(.popToHomeView)
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
      
      case .setIsLoading(let isLoading):
        state.isLoading = isLoading
        return .none
        
      case .pushToSelectCareConditionsView:
        return .none
        
      case .popToHomeView:
        return .none
      }
    }
  }
}
