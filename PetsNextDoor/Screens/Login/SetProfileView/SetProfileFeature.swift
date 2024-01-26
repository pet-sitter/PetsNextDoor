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
  @Dependency(\.userService) private var userService
	
	struct State: Equatable {
    var userRegisterModel: PND.UserRegistrationModel
    var selectedUserImage: UIImage?
    var selectedUserImageData: Data?
    var nicknameStatusPhrase: String = ""
    var isBottomButtonEnabled: Bool   = false
    var photoPickerIsPresented: Bool  = false
    var isLoading: Bool = false
    
    @Pulse var myPetCellViewModels: [SelectPetViewModel] = []
    
    var nicknameText: String = ""

    @PresentationState var selectEitherCatOrDogState: SelectEitherCatOrDogFeature.State?
  

    init(userRegisterModel: PND.UserRegistrationModel) {
      self.userRegisterModel = userRegisterModel
    }
	}
	
	enum Action: Equatable {

    case onImageDataChange(Data?)
    

    case textDidChange(String?)
    
    
    case didTapBottomButton



    case didTapAddPetButton
    case didTapPetDeleteButton(SelectPetViewModel)
    
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
	
	var body: some Reducer<State, Action> {
		Reduce { state, action in
      
      switch action {
      case ._selectEitherCatOrDogAction(.presented(.delegate(.onPetAddComplete(let addPetState)))):
        let selectPetViewModel = SelectPetViewModel(
          petImage: addPetState.petImage,
          petName: addPetState.petName,
          petSpecies: addPetState.speciesType,
          petAge: addPetState.petAge ?? 1,
          isPetNeutralized: addPetState.isNeutralized,
          isPetSelected: false,
          gender: addPetState.gender,
          petType: addPetState.selectedPetType,
          birthday: addPetState.birthday ?? "",
          weight: addPetState.weight ?? 0,
          isDeleteButtonHidden: false
        )

        state.selectEitherCatOrDogState = nil 
        state.myPetCellViewModels.append(selectPetViewModel)
        return .none
        
      case ._selectEitherCatOrDogAction(.presented(.delegate(.dismissComplete))):
        state.selectEitherCatOrDogState = nil
        return .none
        
      case .onImageDataChange(let imageDatas):
        state.selectedUserImageData = imageDatas
        return .none
        
      case .didTapBottomButton:
        return .run { [state] send in
          await send(._setIsLoading(true))
          do {
            
            let _ = try await loginService.registerUser(
              model: state.userRegisterModel,
              profileImageData: state.selectedUserImageData
            )
            
            // 회원가입 성공하면 이후 즉시 내 반려동물 등록
            
            let _ = try await userService.registerMyPets(
              state.myPetCellViewModels.map { petVM -> PND.Pet in
                PND.Pet(
                  id: nil,
                  name: petVM.petName,
                  pet_type: petVM.petType,
                  sex: petVM.gender,
                  neutered: petVM.isPetNeutralized,
                  breed: petVM.petSpecies,
                  birth_date: petVM.birthday,
                  weight_in_kg: petVM.weight
                )
              }
            )
  
            
//            await send(._routeAction(.changeRootScreen(toScreen: .main(
//              homeState: HomeFeature.State(),
//              communityState: CommunityFeature.State(),
//              chatState: ChatListFeature.State(),
//              myPageState: MyPageFeature.State()
//            ))))
            
          } catch {
            print("❌ registerUser failed: \(error)")
          }
          await send(._setIsLoading(false))
        }
        
      case .textDidChange(let text):
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

        
        
      case .didTapAddPetButton:
        state.selectEitherCatOrDogState = .init()
        return .none
        
      case .didTapPetDeleteButton(let petVM):
        state.myPetCellViewModels = state
          .myPetCellViewModels
          .filter { $0 == petVM }
        
        return .none

      case ._appendSelectPetViewModel(let petVM):
        state.myPetCellViewModels.append(petVM)
        return .none

      case ._setNicknameStatusPhrase(let phrase):
        state.nicknameStatusPhrase = phrase
        return .none
        
      case ._setNicknameText(let text):
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
    .ifLet(
      \.$selectEitherCatOrDogState,
       action: /Action._selectEitherCatOrDogAction
    ) {
      SelectEitherCatOrDogFeature()
    }
    

	}
}
