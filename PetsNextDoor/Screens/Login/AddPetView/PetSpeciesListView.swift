//
//  PetSpeciesListView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/30.
//

import SwiftUI
import ComposableArchitecture

struct PetSpeciesListFeature: Reducer {
  
  @Dependency(\.petService) var petService
  
  struct State: Hashable {
    var breedInfo: [PND.BreedInfo] = []
    var petOptions: [PND.PetType] = [.cat, .dog]
    var selectedPet: PND.PetType = .cat
    var selectedBreed: PND.BreedInfo?
  }
  
  enum Action: Equatable {
    case onAppear
    case fetchBreeds
    case setBreedInfo([PND.BreedInfo])
    case onSelectedPetChange(PND.PetType)
    case onSelectedBreedChange(PND.BreedInfo)
  }
  
  var body: some Reducer<State,Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.fetchBreeds)
        
      case .fetchBreeds:
        return .run { [petType = state.selectedPet] send in
          let breedListModel = try await petService.getBreeds(pageSize: 300, petType: petType)
          await send(.setBreedInfo(breedListModel.items))
        }
        
      case let .setBreedInfo(breedInfo):
        state.breedInfo = breedInfo
        return .none
        
      case let .onSelectedPetChange(petType):
        state.selectedPet = petType
        return .run { send in
          await send(.fetchBreeds)
        }
        
      case .onSelectedBreedChange(let breed):
        state.selectedBreed = breed
        return .none
      }
    }
  }
}

struct PetSpeciesListView: View {
  
  let store: StoreOf<PetSpeciesListFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        Picker(
          selection: viewStore.binding(
            get: \.selectedPet,
            send: { .onSelectedPetChange($0) }
          ),
          label: Text(""),
          content: {
            ForEach(viewStore.petOptions, id: \.self) { petType in
              switch petType {
              case .cat:
                Text("고양이")
              case .dog:
                Text("강아지")
              }
            }
          }
        )
        .pickerStyle(.segmented)
        .padding()


        SwiftUI.List {
          ForEach(viewStore.breedInfo, id: \.id) { breedInfo in
            HStack {
              Text(breedInfo.name)
              Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
              viewStore.send(.onSelectedBreedChange(breedInfo))
            }
          }
        }
      }
      .onAppear { viewStore.send(.onAppear) }
    }
  }

}

#Preview {
  PetSpeciesListView(store: .init(initialState: .init(), reducer: { PetSpeciesListFeature() }))
}
