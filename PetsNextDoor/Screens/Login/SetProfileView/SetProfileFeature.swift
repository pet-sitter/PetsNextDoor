//
//  SetProfileFeature.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/08/22.
//
import UIKit
import ComposableArchitecture

struct SetProfileFeature: Reducer {
  
  @Dependency(\.loginService) private var loginService
  @Dependency(\.mediaService) private var mediaService
  @Dependency(\.userService)  private var userService
  @Dependency(\.userDefaultsManager) private var userDefaultsManager
	
	struct State: Equatable {
    var userRegisterModel: PND.UserRegistrationModel
    var selectedUserImageData: Data?
    var nicknameText: String          = ""
    var nicknameStatusPhrase: String  = ""
    var isBottomButtonEnabled: Bool   = false
    var photoPickerIsPresented: Bool  = false
    var isLoading: Bool               = false
    
    var petViewModels: [SelectPetViewModel] = []
    
    var isAddPetFlowPresented: Bool = false
    @PresentationState var selectEitherCatOrDogState: SelectEitherCatOrDogFeature.State?

    init(userRegisterModel: PND.UserRegistrationModel) {
      self.userRegisterModel = userRegisterModel
    }
	}
	
	enum Action: Equatable, BindableAction {
    
    case binding(BindingAction<State>)

    // View Actions
    case onUserProfileImageDataChange(Data?)
    case onNicknameTextChange(String?)
    case onTapAddPetButton
    case onTapPetDeleteButton(SelectPetViewModel)
    case onTapBottomButton
    
    // Internal Actions
    case _appendSelectPetViewModel(SelectPetViewModel)
    case _setNicknameStatusPhrase(String)
    case _setNicknameText(String)
    case _checkNicknameDuplication(String)
    case _setIsBottomButtonEnabled(Bool)
    case _setIsLoading(Bool)

    // Child Actions
    case _selectEitherCatOrDogAction(PresentationAction<SelectEitherCatOrDogFeature.Action>)
	}
  
  init() {}
	
	var body: some Reducer<State, Action> {
    
    BindingReducer()
    
		Reduce { state, action in
      
      switch action {
      
      case ._selectEitherCatOrDogAction(.presented(.delegate(.onPetAddComplete(let addPetState)))):

        guard let breed = addPetState.selectedBreedName
        else { return .none }

        let selectPetViewModel = SelectPetViewModel(
          petImageData: addPetState.selectedPetImageData,
          petName: addPetState.petName,
          petSpecies: breed,
          petAge: addPetState.petAge ?? 1,
          isPetNeutralized: addPetState.isNeutralized,
          isPetSelected: false,
          gender: addPetState.gender,
          petType: addPetState.selectedPetType,
          birthday: addPetState.birthday,
          weight: addPetState.weight ?? 0,
          isDeleteButtonHidden: false
        )

        state.selectEitherCatOrDogState = nil 
        state.petViewModels.append(selectPetViewModel)
        return .none
        
      case ._selectEitherCatOrDogAction(.presented(.delegate(.dismissComplete))):
        state.selectEitherCatOrDogState = nil
        return .none
        
      case .onUserProfileImageDataChange(let imageData):
        state.selectedUserImageData = imageData
        return .none
        
      case .onTapBottomButton:
        return .run { [state] send in
          
          await send(._setIsLoading(true))
          
          do {
            
            var userRegistrationModel = state.userRegisterModel
            
            if let userProfileImageData = state.selectedUserImageData {
              
              let uploadResponse = try await mediaService.uploadImage(
                imageData: userProfileImageData,
                imageName: "profileImage"
              )
              
              userRegistrationModel.profileImageId = uploadResponse.id
              
              let _ = try await loginService.registerUser(model: userRegistrationModel)
              
            } else {
              let _ = try await loginService.registerUser(model: userRegistrationModel)
            }
            
            if state.petViewModels.isEmpty == false {
              /*
               회원 가입 성공하면
               1. 반려동물 프로필 사진 모두 업로드
               2. 반려동물 등록 API 찌르기
               - 이때 accessToken 정상 등록되어야 함
               */
              
              for petVM in state.petViewModels {
                if let imageData = petVM.petImageData {
                  let uploadResponse = try await mediaService.uploadImage(imageData: imageData, imageName: "myPet-\(Int(arc4random()))")
                  petVM.profileImageId = uploadResponse.id
                }
              }
        
              let petArray: [PND.Pet] = state.petViewModels.map { petVM -> PND.Pet in
                PND.Pet(
                  id: Int(arc4random()),
                  name: petVM.petName,
                  petType: petVM.petType,
                  sex: petVM.gender,
                  neutered: petVM.isPetNeutralized,
                  breed: petVM.petSpecies,
                  birthDate: petVM.birthday,
                  weightInKg: petVM.weight ?? 0,
                  remarks: "",
                  profileImageId: petVM.profileImageId
                )
              }
              
              let _ = try await userService.registerMyPets(petArray)
            }
            
            userDefaultsManager.set(.isLoggedIn, to: true)
            Router.changeRootViewToHomeView()
            
          } catch {
            print("❌ registerUser failed: \(error)")
          }
          await send(._setIsLoading(false))
        }
        
      case .onNicknameTextChange(let text):
        guard let text else { return .none }
        if text.count >= 2 && text.count <= 10 {
          return .merge([
            .send(._setNicknameText(text)),
            .send(._checkNicknameDuplication(text))
          ])
        } else {
          return .merge([
            .send(._setNicknameText(text)),
            .send(._setNicknameStatusPhrase("")),
            .send(._setIsBottomButtonEnabled(false))
          ])
        }

      case .onTapAddPetButton:
        state.selectEitherCatOrDogState = .init()
        return .none
        
      case .onTapPetDeleteButton(let petVM):
        state.petViewModels.removeAll(where: { $0 === petVM })
        return .none

      case ._appendSelectPetViewModel(let petVM):
        state.petViewModels.append(petVM)
        return .none

      case ._setNicknameStatusPhrase(let phrase):
        state.nicknameStatusPhrase = phrase
        return .none
        
      case ._setNicknameText(let text):
        
        if text.count > 10 {
          let previousNickname = state.nicknameText
          state.nicknameText = previousNickname
          return .none
        }
        
        state.nicknameText = text
        state.userRegisterModel.nickname = text
        return .none
        
      case ._checkNicknameDuplication:
        return .run { [nickname = state.nicknameText] send in
          do {
            let isNicknameAvailable = try await userService.checkNicknameDuplication(nickname).isAvailable
            
            await send(._setNicknameStatusPhrase(isNicknameAvailable ? "사용 가능한 닉네임이에요." : "이미 사용 중인 닉네임이에요."))
            await send(._setIsBottomButtonEnabled(isNicknameAvailable ? true : false ))
          } catch {
            print("❌ check nickname duplication error: \(error)")
          }
        }
        
      case ._setIsBottomButtonEnabled(let isEnabled):
        state.isBottomButtonEnabled = isEnabled
        return .none
        
      case ._setIsLoading(let isLoading):
        state.isLoading = isLoading
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.$selectEitherCatOrDogState, action: /Action._selectEitherCatOrDogAction) { SelectEitherCatOrDogFeature() }
	}
}
