//
//  SelectOtherRequirementsView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/12.
//

import SwiftUI
import ComposableArchitecture

struct SelectOtherRequirementsFeature: Reducer {
  
  @Dependency(\.sosPostService) var postService
  
  struct State: Hashable {
    var conditions: [Condition] = []
    var isBottomButtonEnabled: Bool = true
    var urgentPostModel: PND.UrgentPostModel
    
    init(urgentPostModel: PND.UrgentPostModel) {
      self.urgentPostModel = urgentPostModel
    }
  }
  
  enum Action: Equatable {
  
    case onAppear
    case setBottomButtonEnabled(Bool)
    case onConditionCheckBoxTap(index: Int)
    case onBottomButtonTap
    
    // Internal Cases
    case _setConditions([Condition])
    case _toggleCheckBoxValue(index: Int)

    case pushToWriteUrgentPostView(PND.UrgentPostModel)
  }
  
  struct Condition: Hashable {
    let id: Int
    let name: String
    var isSelected: Bool = false
  }
  
  var body: some Reducer<State,Action> {
    Reduce { state, action in
      switch action {
        
      case .onAppear:
        guard state.conditions.isEmpty else { return .none }
        
        return .run { send in
          
          let pndConditions = try await postService.getSOSConditions()
          
//          let conditions: [Condition] = pndConditions.map { Condition(id: $0.id, name: $0.name) }
//        
//          await send(._setConditions(conditions))
          
        } catch: { error, send in
          print("❌ error fetching conditions: \(error)")
        }
        
      case ._setConditions(let conditions):
        state.conditions = conditions
        return .none
        
      case .setBottomButtonEnabled(let isEnabled):
        state.isBottomButtonEnabled = isEnabled
        return .none
        
      case .onConditionCheckBoxTap(let index):
        state.conditions[index].isSelected.toggle()
        
        state.urgentPostModel.conditionIds = state.conditions.filter(\.isSelected).map(\.id)

        return .none
        
      case .onBottomButtonTap:
        return .send(.pushToWriteUrgentPostView(state.urgentPostModel))
        
      case ._toggleCheckBoxValue(let index):
        state.conditions[index].isSelected.toggle()
        return .none
        
      case .pushToWriteUrgentPostView:
        return .none

      }
    }
  }
}

struct SelectOtherRequirementsView: View {
  
  let store: StoreOf<SelectOtherRequirementsFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      
      VStack(alignment: .leading) {
        Spacer().frame(height: PND.Metrics.defaultSpacing)
        
        Text("기타 요청사항")
          .font(.system(size: 20, weight: .bold))
          .padding(.leading, 20)
        
        ForEach(0..<viewStore.conditions.count, id: \.self) { index in
          
          Spacer().frame(height: PND.Metrics.defaultSpacing)
          
          SelectConditionView(
            leftImageName: nil,
            conditionTitle: viewStore.conditions[index].name,
            rightContentView: {
              CheckBoxView(isSelected: viewStore.binding(
                get: \.conditions[index].isSelected,
                send: { _ in .onConditionCheckBoxTap(index: index)}
              ))
            }
          )
        }
        
        Spacer()
        
        BaseBottomButton_SwiftUI(
          title: "다음 단계로",
          isEnabled: viewStore.binding(
            get: \.isBottomButtonEnabled,
            send: { .setBottomButtonEnabled($0) }
          )
        )
        .onTapGesture {
          viewStore.send(.onBottomButtonTap)
        }
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
}

//#Preview {
//  SelectOtherRequirementsView(store: .init(initialState: .init(urgentPostModel: .default()), reducer: { SelectOtherRequirementsFeature() }))
//}
