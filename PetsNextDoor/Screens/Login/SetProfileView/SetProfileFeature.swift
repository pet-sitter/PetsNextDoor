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
  @Dependency(\.uploadService) private var uploadService
	
	struct State: Equatable, RoutableState {
    var userRegisterModel: PND.UserRegistrationModel
    var nicknameStatusPhrase: String = ""
    var selectedUserImage: UIImage?
    var isBottomButtonEnabled: Bool   = true
    var photoPickerIsPresented: Bool  = false
    var isLoading: Bool = false
    
    @Pulse var myPetCellViewModels: [SelectPetViewModel] = []
    
    fileprivate var nicknameText: String = ""

    var selectEitherCatOrDogState: SelectEitherCatOrDogFeature.State?
		
		var router: Router<PND.Destination>.State = .init()
    
    init(userRegisterModel: PND.UserRegistrationModel) {
      self.userRegisterModel = userRegisterModel
    }
	}
	
	enum Action: Equatable, RoutableAction {
    case didTapBottomButton
		case textDidChange(String?)
    case userImageDidChange(UIImage)
    case profileImageDidTap
    case didTapAddPetButton
    case didTapPetDeleteButton(SelectPetViewModel)
    
    // Internal Actions
    case _appendSelectPetViewModel(SelectPetViewModel)
    case _setNicknameStatusPhrase(String)
    case _setNicknameText(String)
    case _setIsBottomButtonEnabled(Bool)
    case _setIsLoading(Bool)
		case _routeAction(Router<PND.Destination>.Action)
    
    // Child Actions
    case _selectEitherCatOrDogAction(SelectEitherCatOrDogFeature.Action)
	}
	
	var body: some Reducer<State, Action> {
    
		Scope(
			state: \.router,
			action: /Action._routeAction
		) {
			Router<PND.Destination>()
		}
    
    
		Reduce { state, action in
      
      switch action {
        
      case ._selectEitherCatOrDogAction(.delegate(.onPetAddComplete(let addPetState))):
        
        let selectPetViewModel = SelectPetViewModel(
          petImage: addPetState.petImage,
          petName: addPetState.petName,
          petSpecies: addPetState.speciesType,
          petAge: addPetState.petAge ?? 1,
          isPetNeutralized: addPetState.isNeutralized,
          isPetSelected: false,
          isDeleteButtonHidden: false
        )

        state.selectEitherCatOrDogState = nil 
        state.myPetCellViewModels.append(selectPetViewModel)
        return .none
        
      case ._selectEitherCatOrDogAction(.delegate(.dismissComplete)):
        state.selectEitherCatOrDogState = nil
        return .none
        
      case .didTapBottomButton:
        state.userRegisterModel.nickname = state.nicknameText
        
        return .run { [state] send in
          await send(._setIsLoading(true))
          do {
            if let userProfileImage = state.selectedUserImage, let imageData = userProfileImage.jpegData(compressionQuality: 0.7) {
              let imageModel = try await uploadService.uploadImage(
                imageData: imageData,
                imageName: "profileImage"
              )
              
            
            }
            
            let _ = try await loginService.registerUser(model: state.userRegisterModel)
            
            
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
            .send(._setNicknameStatusPhrase("사용 가능한 닉네임이예요.")),
            .send(._setIsBottomButtonEnabled(true))
          ])
        } else {
          return .merge([
            .send(._setNicknameText(text)),
            .send(._setNicknameStatusPhrase("")),
            .send(._setIsBottomButtonEnabled(false))
          ])
        }

      case .userImageDidChange(let image):
        state.photoPickerIsPresented = false
        state.selectedUserImage = image
        return .none
        
      case .profileImageDidTap:
        state.photoPickerIsPresented = true
        return .none
        
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
        return .none
        
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
      \.selectEitherCatOrDogState,
       action: /Action._selectEitherCatOrDogAction
    ) {
      SelectEitherCatOrDogFeature()
    }
    

	}
}
