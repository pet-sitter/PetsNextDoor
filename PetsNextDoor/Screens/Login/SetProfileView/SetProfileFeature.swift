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
		
	}
	
	enum Action: Equatable {
		
	}
	
	var body: some Reducer<State, Action> {
		Reduce { state, action in
			return .none
		}
	}
}
