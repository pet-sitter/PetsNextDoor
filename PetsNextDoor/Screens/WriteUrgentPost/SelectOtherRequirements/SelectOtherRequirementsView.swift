//
//  SelectOtherRequirementsView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/12.
//

import SwiftUI
import ComposableArchitecture

struct SelectOtherRequirementsFeature: Reducer {
  
  struct State: Equatable {
    
    var cctvAgreed: Bool    = false
    var idAgreed: Bool      = false
    var preCallAgreed: Bool = false
    
    var isBottomButtonEnabled: Bool = true
    
    fileprivate var router: Router<PND.Destination>.State = .init()
  }
  
  enum Action: Equatable {
  
    case didTapBottomButton
    case setBottomButtonEnabled(Bool)
    
    case onCCTVAgreedCheckBoxTap(Bool)
    case onIdAgreedCheckBoxTap(Bool)
    case onPreCallAgreedCheckBoxTap(Bool)
    
    // Internal Cases
    case _routeAction(Router<PND.Destination>.Action)
  }
  
  var body: some Reducer<State,Action> {
    
    Scope(
      state: \.router,
      action: /Action._routeAction
    ) {
      Router<PND.Destination>()
    }
    
    Reduce { state, action in
      switch action {
      case .didTapBottomButton:
        return .send(._routeAction(.pushScreen(.writeUrgentPost(state: .init()), animated: true)))
        
      case .setBottomButtonEnabled(let isEnabled):
        state.isBottomButtonEnabled = isEnabled
        return .none
        
      case .onCCTVAgreedCheckBoxTap(let isSelected):
        state.cctvAgreed = isSelected
        return .none
        
      case .onIdAgreedCheckBoxTap(let isSelected):
        state.idAgreed = isSelected
        return .none
        
      case .onPreCallAgreedCheckBoxTap(let isSelected):
        state.preCallAgreed = isSelected
        return .none
        
      default:
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
        
        Text(titleAttributedString)
          .font(.system(size: 20, weight: .bold))
          .padding(.leading, 20)
        
        Spacer().frame(height: 20)
        
        SelectConditionView(
          leftImageName: nil,
          conditionTitle: "· CCTV, 펫캠 촬영 동의",
          rightContentView: {
            CheckBoxView(isSelected: viewStore.binding(
              get: \.cctvAgreed,
              send: { .onCCTVAgreedCheckBoxTap($0) })
            )
          }
        )
        
        Spacer().frame(height: PND.Metrics.defaultSpacing)
        
        SelectConditionView(
          leftImageName: nil,
          conditionTitle: "· 신분증 인증",
          rightContentView: {
            CheckBoxView(isSelected: viewStore.binding(
              get: \.idAgreed,
              send: { .onIdAgreedCheckBoxTap($0) })
            )
          }
        )
        
        Spacer().frame(height: PND.Metrics.defaultSpacing)
        
        SelectConditionView(
          leftImageName: nil,
          conditionTitle: "· 사전 통화 가능 여부",
          rightContentView: {
            CheckBoxView(isSelected: viewStore.binding(
              get: \.preCallAgreed,
              send: { .onPreCallAgreedCheckBoxTap($0) })
            )
          }
        )
        
        Spacer()
        
        BaseBottomButton_SwiftUI(
          title: "다음 단계로",
          isEnabled: viewStore.binding(
            get: \.isBottomButtonEnabled,
            send: { .setBottomButtonEnabled($0) }
          )
        )
        .onTapGesture {
          viewStore.send(.didTapBottomButton)
        }
        
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

#Preview {
  SelectOtherRequirementsView(store: .init(initialState: .init(), reducer: { SelectOtherRequirementsFeature() }))
}
