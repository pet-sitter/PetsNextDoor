//
//  MyPageView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/22.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct MyPageFeature: Reducer {
  
  @Dependency(\.petService) var petService
  
  @ObservableState
  struct State: Equatable {
    
    var myPets: [PND.Pet] = []
    var myPetViewModels: [SelectPetViewModel] = []
  }
  
  enum Action: RestrictiveAction, BindableAction {
    
    enum ViewAction: Equatable {
      case onAppear
    }
    
    enum InternalAction: Equatable {
      case fetchMyPets
      case setMyPets([PND.Pet])
    }
    
    enum DelegateAction: Equatable {
      
    }
    
    case view(ViewAction)
    case `internal`(InternalAction)
    case delegate(DelegateAction)
    case binding(BindingAction<State>)
  }
  
  var body: some Reducer<State, Action> {
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .view(.onAppear):
        return .run { send in
          
          await send(.internal(.fetchMyPets))
        }
        
      case .internal(.fetchMyPets):
        return .run { send in
          
          let myPets: [PND.Pet] = try await petService.getMyPets().pets
          await send(.internal(.setMyPets(myPets)))
          
        } catch: { error, send in
          PNDLogger.network.error("Failed fetching ")
        }
        
      case .internal(.setMyPets(let pets)):
        state.myPets = pets
        state.myPetViewModels = pets.map {
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
        
      case .delegate:
        return .none
        
      case .binding:
        return .none
      }
    }
  }
}


struct MyPageView: View {
  
  @State var store: StoreOf<MyPageFeature>
  
  var body: some View {
    VStack {
      topNavigationBarView
      
      ScrollView(.vertical) {
        
        
        ForEach(store.myPetViewModels, id: \.id) { vm in
            SelectPetView(viewModel: vm, onDeleteButtonTapped: nil)
        }
        
        
        RoundedRectangle(cornerRadius: 4)
          .frame(height: 54)
          .padding(.horizontal, PND.Metrics.defaultSpacing)
          .foregroundStyle(PND.Colors.gray20.asColor)
          .contentShape(Rectangle())
          .overlay(
            Button("반려동물 추가하기", systemImage: "plus") {
            }
              .foregroundStyle(.black)
          )

      }
      
      
    }
    .onAppear {
      store.send(.view(.onAppear))
    }
  }
  
  private var topNavigationBarView: some View {
    HStack {
      Spacer().frame(width: PND.Metrics.defaultSpacing)

      
      Text("마이페이지")
        .foregroundStyle(PND.Colors.commonBlack.asColor)
        .font(.system(size: 20, weight: .bold))
    
      Spacer()
      
      Button(action: {
  
      }, label: {
        Image(R.image.icon_setting)
          .resizable()
          .frame(width: 24, height: 24)
          .tint(PND.Colors.commonBlack.asColor)
      })
      
      Spacer().frame(width: PND.Metrics.defaultSpacing)
    }
  }
}

#Preview {
  MyPageView(store: .init(initialState: .init(), reducer: { MyPageFeature() }))
}
