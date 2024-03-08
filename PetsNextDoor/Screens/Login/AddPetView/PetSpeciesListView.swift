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
    var searchText: String = ""
    var breedList: [String] = []
    var breedInfo: [PND.BreedInfo] = []
    var petOptions: [PND.PetType] = [.cat, .dog]
    var selectedBreed: PND.BreedInfo?
    let selectedPet: PND.PetType
  }
  
  enum Action: Equatable {
    case onAppear
    case onSearchTextChange(String)
    case fetchBreeds
    case setBreedInfo([PND.BreedInfo])
    case onBreedSelection(String)
  }
  
  var body: some Reducer<State,Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.fetchBreeds)
        
      case .onSearchTextChange(let text):
        state.searchText = text
        state.breedList = state.breedInfo
          .map(\.name)
          .filter { $0.hasPrefix(text) }
        return .none
        
      case .fetchBreeds:
        return .run { [petType = state.selectedPet] send in
          let breedListModel = try await petService.getBreeds(pageSize: 300, petType: petType)
          await send(.setBreedInfo(breedListModel.items))
        }
        
      case let .setBreedInfo(breedInfo):
        state.breedInfo = breedInfo
        state.breedList = breedInfo.map(\.name)
        return .none
        
      case .onBreedSelection(let breedName):
        if let selectedBreed = state.breedInfo.first(where: { $0.name == breedName }) {
          state.selectedBreed = selectedBreed
        }
        return .none
      }
    }
  }
}

struct PetSpeciesListView: View {
  
  let store: StoreOf<PetSpeciesListFeature>
  
  @State var text: String = ""
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationStack {
        if viewStore.breedList.isEmpty {
          Text("검색 결과가 없습니다.")
        } else {
          SwiftUI.List {
            ForEach(viewStore.breedList, id: \.self) { breed in
              HStack {
                Text(breed)
                Spacer()
              }
              .contentShape(Rectangle())
              .onTapGesture {
                viewStore.send(.onBreedSelection(breed))
              }
            }
            .listRowSeparator(.hidden)
          }
          .listStyle(.plain)
        }
      }
      .searchable(text: viewStore.binding(
        get: \.searchText,
        send: { .onSearchTextChange($0) }
      ))
      .padding(.top, 5)
      .onAppear { viewStore.send(.onAppear) }
    }
  }
  
}

#Preview {
  PetSpeciesListView(store: .init(initialState: .init(selectedPet: .cat), reducer: { PetSpeciesListFeature() }))
}
