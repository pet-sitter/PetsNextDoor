//
//  MyPetInfoFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/05/15.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct MyPetInfoFeature: Reducer {
  
  @Dependency(\.petService) var petService
  @Dependency(\.userService) var userService
  @Dependency(\.mediaService) var mediaService
  
  @ObservableState
  struct State: Equatable {
    var myPets: [PND.Pet] = []
    var myPetVMs: [SelectPetViewModel] = []
    
    var isAddPetViewPresented: Bool = false
    var selectEitherCatOrDogState: SelectEitherCatOrDogFeature.State?
  }
  
  enum Action: Equatable, BindableAction {
    case onAppear
    case onTapAddPetButton
    
    case setMyPets([PND.Pet])
    case setIsAddPetViewPresented(Bool)
    
    case selectEitherCatOrDogAction(SelectEitherCatOrDogFeature.Action)
    case binding(BindingAction<State>)
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          let myPets: [PND.Pet] = try await petService.getMyPets().pets
          await send(.setMyPets(myPets))
        } catch: { error, send in
          PNDLogger.network.error("Failed fetching my pets")
        }
        
      case .onTapAddPetButton:
        return .send((.setIsAddPetViewPresented(true)))
        
      case .setMyPets(let pets):
        state.myPets = pets
        state.myPetVMs = pets.map {
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
        
      case .setIsAddPetViewPresented(let isPresented):
        state.isAddPetViewPresented     = isPresented
        state.selectEitherCatOrDogState = .init()
        return .none
        
        // Child Actions
        
      case .selectEitherCatOrDogAction(let action):
        
        switch action {
        case .delegate(.dismissComplete):
          state.isAddPetViewPresented     = false
          state.selectEitherCatOrDogState = nil
          
        case .delegate(.onPetAddComplete(let addPetState)):
          guard let breed = addPetState.selectedBreedName
          else { return .none }
          
          let newPetViewModel = SelectPetViewModel(
            petImageData: addPetState.selectedPetImageData,
            petName: addPetState.petName,
            petSpecies: breed,
            petAge: addPetState.petAge ?? 1,
            isPetNeutralized: addPetState.isNeutralized,
            isPetSelected: false,
            gender: addPetState.gender,
            petType: addPetState.selectedPetType,
            birthday: addPetState.birthday,
            weight: addPetState.weight?.asString() ?? "0",
            remarks: addPetState.cautionText,
            isDeleteButtonHidden: true
          )
          
          state.myPetVMs.append(newPetViewModel)
          state.isAddPetViewPresented     = false
          state.selectEitherCatOrDogState = nil
          
          return registerNewPet(using: newPetViewModel)

        default:
          break
        }
        
        return .none
        
      case .binding:
        return .none
      }
    }
    .ifLet(\.selectEitherCatOrDogState, action: \.selectEitherCatOrDogAction) {
      SelectEitherCatOrDogFeature()
    }
  }
  
  
  private func registerNewPet(using petViewModel: SelectPetViewModel) -> Effect<Action> {
    .run { send in
      
      if let petImageData = petViewModel.petImageData {
        let imageId = await uploadPetProfileImage(withImageData: petImageData)
        petViewModel.profileImageId = imageId
      }
      
      try await registerMyPet(using: petViewModel)
      
    } catch: { error, send in
      Toast.shared.present(title: .commonError, symbolType: .xMark)
    }
  }
  
  private func registerMyPet(using petViewModel: SelectPetViewModel) async throws {
    let petModel: PND.Pet = PND.Pet(
      id: Int(arc4random()),
      name: petViewModel.petName,
      petType: petViewModel.petType,
      sex: petViewModel.gender,
      neutered: petViewModel.isPetNeutralized,
      breed: petViewModel.petSpecies,
      birthDate: petViewModel.birthday,
      weightInKg: petViewModel.weight ?? "0",
      remarks: petViewModel.remarks,
      profileImageId: petViewModel.profileImageId
    )
     
    try await userService.registerMyPets([petModel])
  }
  
  private func uploadPetProfileImage(withImageData data: Data) async -> Int? {
    let uploadResponse = try? await mediaService.uploadImage(
      imageData: data,
      imageName: "myPet-\(Int(arc4random()))"
    )
    return uploadResponse?.id
  }
  
}


struct MyPetInfoView: View {
  
  @State var store: StoreOf<MyPetInfoFeature>
  
  var body: some View {
    LazyVStack(spacing: 8) {
      ForEach(store.myPetVMs, id: \.id) { vm in
        SelectPetView(viewModel: vm, onDeleteButtonTapped: nil)
      }
      
      AddPetButtonView {
        store.send(.onTapAddPetButton)
      }
    }
    .fullScreenCover(
      isPresented: $store.isAddPetViewPresented,
      content: {
        IfLetStore(
          store.scope(
            state: \.selectEitherCatOrDogState,
            action: \.selectEitherCatOrDogAction
          )
        ) { store in
          SelectEitherCatOrDogView(store: store)
        }
      }
    )
    .onAppear {
      store.send(.onAppear)
    }
  }
}
