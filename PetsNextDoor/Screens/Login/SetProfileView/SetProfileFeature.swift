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
	
	struct State: Equatable {
    var userRegisterModel: PND.UserRegistrationModel
    var nicknameStatusPhrase: String = ""
    var selectedUserImage: UIImage?
    var isBottomButtonEnabled: Bool = false
    var photoPickerIsPresented: Bool = false
    var isLoading: Bool = false
    
    fileprivate var nicknameText: String = ""
    
    init(userRegisterModel: PND.UserRegistrationModel) {
      self.userRegisterModel = userRegisterModel
    }
	}
	
	enum Action: Equatable {
    case didTapBottomButton
		case textDidChange(String?)
    case userImageDidChange(UIImage)
    case profileImageDidTap
    
    // Internal Actions
    case _setNicknameStatusPhrase(String)
    case _setNicknameText(String)
    case _setIsBottomButtonEnabled(Bool)
    case _setIsLoading(Bool)
	}
	
	var body: some Reducer<State, Action> {
		Reduce { state, action in
      
      switch action {
        
      case .didTapBottomButton:
        state.userRegisterModel.nickname = state.nicknameText
        
        return .run { [registerModel = state.userRegisterModel] send in
          await send(._setIsLoading(true))
          do {
            let _ = try await loginService.registerUser(model: registerModel)
            
            
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
      }

		}
	}
}
