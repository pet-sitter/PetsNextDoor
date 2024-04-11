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
    
    var conditions: [PND.Condition] = []

    var isBottomButtonEnabled: Bool = false
    
    var urgentPostModel: PND.UrgentPostModel
    
    // Child State
    @PresentationState var writeUrgentPostState: WriteUrgentPostFeature.State?
    
  }
  
  enum Action: Equatable {
  
    case onAppear
    case setBottomButtonEnabled(Bool)
    case onConditionCheckBoxTap(index: Int)
    case onBottomButtonTap
    
    // Internal Cases
    case _setConditions([PND.Condition])
    case _toggleCheckBoxValue(index: Int)
    
    // Child Action
    case writeUrgentPostAction(PresentationAction<WriteUrgentPostFeature.Action>)
    
  }
  
  var body: some Reducer<State,Action> {
    Reduce { state, action in
      switch action {
        
      case .onAppear:
        guard state.conditions.isEmpty else { return .none }
        
        return .run { send in
          
//          let conditions = try await postService.getSOSConditions()
          let conditions = try await MockSosPostService().getSOSConditions()
        
          await send(._setConditions(conditions))
          
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
        
        if state.conditions.map(\.isSelected).contains(true) {
          return .send(.setBottomButtonEnabled(true))
        } else {
          return .send(.setBottomButtonEnabled(false ))
        }
        
      case .onBottomButtonTap:
        state.writeUrgentPostState = WriteUrgentPostFeature.State(urgentPostModel: state.urgentPostModel)
        return .none
        
      case ._toggleCheckBoxValue(let index):
        state.conditions[index].isSelected.toggle()
        
        return .none
        
      case .writeUrgentPostAction:
        return .none

      }
    }
    .ifLet(
      \.$writeUrgentPostState,
       action: /Action.writeUrgentPostAction
    ) {
      WriteUrgentPostFeature()
    }
  }
}

struct SelectOtherRequirementsView: View {
  
  let store: StoreOf<SelectOtherRequirementsFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      
      VStack(alignment: .leading) {
        Spacer().frame(height: PND.Metrics.defaultSpacing)
        
        Text(titleAttributedString)
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
      .navigationDestination(
        store: store.scope(
          state: \.$writeUrgentPostState,
          action: { .writeUrgentPostAction($0) }),
        destination: { store in
          WriteUrgentPostView(store: store)
        }
      )
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
  
  
  var titleAttributedString: AttributedString {
    let title = NSAttributedString {
      AText("기타 요청사항")
        .font(.systemFont(ofSize: 20, weight: .bold))
      AText("(필수 선택)")
        .font(.systemFont(ofSize: 20, weight: .bold))
        .foregroundColor(PND.Colors.primary)
    }
    return AttributedString(title)
  }
}

//#Preview {
//  SelectOtherRequirementsView(store: .init(initialState: .init(urgentPostModel: .default()), reducer: { SelectOtherRequirementsFeature() }))
//}
