//
//  SetProfileFeature.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/08/22.
//
import UIKit
import ComposableArchitecture

struct SetProfileFeature: Reducer {
	
	struct State: Equatable {
    
    var nicknameStatusPhrase: String = ""
    var selectedUserImage: UIImage?
    var isBottomButtonEnabled: Bool = false
    var photoPickerIsPresented: Bool = false
    
    fileprivate var nicknameText: String = ""
	}
	
	enum Action: Equatable {
		case textDidChange(String?)
    case userImageDidChange(UIImage)
    case profileImageDidTap
    
    // Internal Actions
    case _setNicknameStatusPhrase(String)
    case _setNicknameText(String)
    case _setIsBottomButtonEnabled(Bool)
	}
	
	var body: some Reducer<State, Action> {
		Reduce { state, action in
      
      switch action {
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
      }

		}
	}
}
