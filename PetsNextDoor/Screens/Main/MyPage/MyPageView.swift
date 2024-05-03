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
  @Dependency(\.userService) var userService
  @Dependency(\.mediaService) var mediaService
  
  @ObservableState
  struct State: Equatable {
    
    var myPets: [PND.Pet] = []
    var myPetViewModels: [SelectPetViewModel] = []
    
    var isAddPetViewPresented: Bool = false
    

    var selectEitherCatOrDogState: SelectEitherCatOrDogFeature.State?
  }
  
  enum Action: RestrictiveAction, BindableAction {
    
    enum ViewAction: Equatable {
      case onAppear
      case onTapAddPetButton
    }
    
    enum InternalAction: Equatable {
      case fetchMyPets
      case setMyPets([PND.Pet])
      case setIsAddPetViewPresented(Bool)
    }
    
    enum DelegateAction: Equatable {
      
    }
    
    case view(ViewAction)
    case `internal`(InternalAction)
    case delegate(DelegateAction)
    case binding(BindingAction<State>)
    case selectEitherCatOrDogAction(SelectEitherCatOrDogFeature.Action)
  }
  
  var body: some Reducer<State, Action> {
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .view(.onAppear):
        return .run { send in
          
          await send(.internal(.fetchMyPets))
        }
        
      case .view(.onTapAddPetButton):
        
        return .send(.internal(.setIsAddPetViewPresented(true)))
        
      case .internal(.fetchMyPets):
        return .run { send in
          
          let myPets: [PND.Pet] = try await petService.getMyPets().pets
          await send(.internal(.setMyPets(myPets)))
          
        } catch: { error, send in
          PNDLogger.network.error("Failed fetching my pets")
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
        
      case .internal(.setIsAddPetViewPresented(let isPresented)):
        state.isAddPetViewPresented     = isPresented
        state.selectEitherCatOrDogState = .init()
        return .none
        
      case .delegate:
        return .none
        
      case .binding:
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
            isDeleteButtonHidden: false
          )
          
          state.myPetViewModels.append(newPetViewModel)
          state.isAddPetViewPresented     = false
          state.selectEitherCatOrDogState = nil
          
          return registerNewPet(using: newPetViewModel)

        default:
          break
        }
        
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
              store.send(.view(.onTapAddPetButton))
            }
              .foregroundStyle(.black)
          )
          .onTapGesture {
            store.send(.view(.onTapAddPetButton))
          }
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
