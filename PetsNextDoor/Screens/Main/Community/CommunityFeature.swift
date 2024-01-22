//
//  CommunityFeature.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/10.
//

import Foundation
import UIKit
import ComposableArchitecture

struct CommunityFeature: Reducer {
  
  struct State: Equatable {
    
    var meetingCardCellViewModels: [MeetingCardViewModel] = []
    
    var tabIndex: Int = 0
    var selectedCategory: SelectCategoryView_SwiftUI.Category = .onlyDogs
    
    
    fileprivate var router: Router<PND.Destination>.State = .init()
  }
  
  enum Action: Equatable {
    case viewDidLoad
    case didTapAddButton
    
    case onTabIndexChange(Int)
    case onSelectedCategoryChange(SelectCategoryView_SwiftUI.Category)
    
    

    // Internal Cases
    case _routeAction(Router<PND.Destination>.Action)
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
        
      case .viewDidLoad:
        for i in 1..<10 {
          state.meetingCardCellViewModels.append(
						MeetingCardViewModel(
              mainImage: UIImage(named: ["dog_test", "dog_test2", "dog_test3", "dog_test4"].randomElement()!)!,
							title: "푸들을 짱 사랑하는 모임 \(i)",
							currentlyGatheredPeople: [1,2,3,4,5].randomElement()!,
							totalGatheringPeople: [6,7,8,9,10,11].randomElement()!,
							activityStatus: ["방금 활동", "1분전", "3일전", "12분전", "2시간전"].randomElement()!,
							tags: ["훈련", "산책", "정보 공유"]
						)
					)
        }
        
        
        return .none

        
      case .didTapAddButton:
        
        return .none
        
      default:
        return .none
      }
    }
  }
}
