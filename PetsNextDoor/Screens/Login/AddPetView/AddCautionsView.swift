//
//  AddCautionsView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/03/08.
//

import SwiftUI
import ComposableArchitecture

struct AddCautionsFeature: Reducer {
  
  struct State: Hashable {
    var remarksText: String = ""
    var cautionsText: String = ""
    
    var isBottomButtonEnabled: Bool = true
  }
  
  enum Action: Equatable {
    case onRemarksTextChange(String)
    case onCautionsTextChange(String)
    case onBottomButtonTap
  }
  
  var body: some Reducer<State,Action> {
    Reduce { state, action in
      switch action {
      case .onRemarksTextChange(let text):
        state.remarksText = text
        return .none
        
      case .onCautionsTextChange(let text):
        state.cautionsText = text
        return .none
        
      case .onBottomButtonTap:
        return .none
      }
    }
  }
}

struct AddCautionsView: View {
  
  let store: StoreOf<AddCautionsFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: 0) {
        
        Spacer().frame(height: PND.Metrics.defaultSpacing)
        
        Text("돌봄시\n참고사항을 알려주세요.")
          .font(.system(size: 20, weight: .bold))
          .modifier(HeaderTitleModifier())
        
        Spacer().frame(height: 20)
        
        TextEditorWithBackground(
          text: viewStore.binding(
            get: \.remarksText,
            send: { .onRemarksTextChange($0) }
          ),
          placeholder: "예) 배변 패드 보관 위치, 사료 섭취 무게 등"
        )
        .padding(.horizontal, PND.Metrics.defaultSpacing)
        
        DefaultSpacer(axis: .vertical)
        
        Text("건강 관련\n주의 사항을 알려주세요.")
          .font(.system(size: 20, weight: .bold))
          .modifier(HeaderTitleModifier())
        Spacer().frame(height: 20)
        
        TextEditorWithBackground(
          text: viewStore.binding(
            get: \.cautionsText,
            send: { .onCautionsTextChange($0) }
          ),
          placeholder: "예) 먹고 있는 약, 앓고 있는 병, 알러지 여부 등"
        )
        .padding(.horizontal, PND.Metrics.defaultSpacing)
        
        Spacer(minLength: 100)
        
        BaseBottomButton_SwiftUI(
          title: "다음으로",
          isEnabled: viewStore.binding(
            get: \.isBottomButtonEnabled,
            send: { .onBottomButtonTap }()
          )
        )
        .onTapGesture {
          viewStore.send(.onBottomButtonTap)
        }
      }
    }
  }
}

#Preview {
  AddCautionsView(store: .init(initialState: .init(), reducer: { AddCautionsFeature() }))
}
