//
//  SetProfileFeature.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/08/22.
//

import Foundation
import ComposableArchitecture

struct SetProfileFeature: Reducer {
	
	struct State: Equatable {
    var nicknameStatusPhrase: String = ""
  
    var nicknameText: String = ""
	}
	
	enum Action: Equatable {
		case textDidChange(String?)
    
    // Internal Actions
    case _setNicknameStatusPhrase(String)
    case _setNicknameText(String)
	}
	
	var body: some Reducer<State, Action> {
		Reduce { state, action in
      
      switch action {
      case .textDidChange(let text):
        guard let text else { return .none }
        if text.count >= 2 && text.count <= 10 {
          return .concatenate(
            .send(._setNicknameText(text)),
            .send(._setNicknameStatusPhrase("사용 가능한 닉네임이예요."))
          )
        } else {
          return .concatenate(
            .send(._setNicknameText(text)),
            .send(._setNicknameStatusPhrase(""))
          )
        }

      case ._setNicknameStatusPhrase(let phrase):
        state.nicknameStatusPhrase = phrase
        return .none
        
      case ._setNicknameText(let text):
        state.nicknameText = text
        return .none
      }

		}
	}
}
