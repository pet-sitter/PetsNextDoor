//
//  SelectOtherRequirementsView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/12.
//

import SwiftUI
import ComposableArchitecture

struct SelectOtherRequirementsFeature: Reducer {
  
  struct State: Hashable {
    
    var conditions: [PND.Condition] = []

    var isBottomButtonEnabled: Bool = false
    
    var urgentPostModel: PND.UrgentPostModel
    
  }
  
  enum Action: Equatable {
  
    case onAppear
    case setBottomButtonEnabled(Bool)
    case onConditionCheckBoxTap(index: Int)
    
    // Internal Cases
    case _toggleCheckBoxValue(index: Int)
  }
  
  var body: some Reducer<State,Action> {

    Reduce { state, action in
      switch action {
        
      case .onAppear:
        state.conditions = [
          .init(id: 0, name: "· CCTV, 펫캠 촬영 동의", isSelected: false),
          .init(id: 1, name: "· 신분증 인증", isSelected: false),
          .init(id: 2, name: "· 사전 통화 가능 여부", isSelected: false)
        ]
        return .none
        
      case .setBottomButtonEnabled(let isEnabled):
        state.isBottomButtonEnabled = isEnabled
        return .none
        
      case .onConditionCheckBoxTap(let index):
        state.conditions[index].isSelected.toggle()
        state.urgentPostModel.conditionIds = state.conditions.map(\.id)
        
        if state.conditions.map(\.isSelected).contains(true) {
          return .send(.setBottomButtonEnabled(true))
        } else {
          return .send(.setBottomButtonEnabled(false ))
        }
        
      case ._toggleCheckBoxValue(let index):
        state.conditions[index].isSelected.toggle()
        
        return .none

      }
    }
  }
}

struct SelectOtherRequirementsView: View {
  
  let store: StoreOf<SelectOtherRequirementsFeature>
  
  @EnvironmentObject var router: Router
  
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
          router.pushScreen(to: WriteUrgentPostFeature.State(urgentPostModel: viewStore.urgentPostModel))
        }
        
      }
      .navigationDestination(for: WriteUrgentPostFeature.State.self, destination: { state in
        WriteUrgentPostView(store: .init(initialState: state, reducer: { WriteUrgentPostFeature() }))
      })
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
