//
//  WriteEventDescriptionView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 11/7/24.
//

import SwiftUI
import ComposableArchitecture


@Reducer
struct WriteEventDescriptionFeature: Reducer {
  
  @ObservableState
  struct State: Equatable {
    var eventUploadModel: PND.EventUploadModel
    var eventTitle: String = ""
    var eventDescription: String = ""
    var selectedImageDatas: [Data] = []
    var isBottomButtonEnabled: Bool = false
  }
  
  enum Action: BindableAction {
    case onBottomButtonTap
    case binding(BindingAction<State>)
  }
  
  var body: some Reducer<State,Action> {
    BindingReducer()
    Reduce { state, action in
      
      switch action {
      case .binding(\.eventDescription):
        state.isBottomButtonEnabled = state.eventDescription.isEmpty ? false : true
        return .none
        
      default:
        return .none
      }
    }
  }
}

struct WriteEventDescriptionView: View {
  
  @State var store: StoreOf<WriteEventDescriptionFeature>
  
  
  var body: some View {
    VStack(alignment: .leading) {
      
      Spacer().frame(height: 18)
      
      TextField(
        "이벤트 이름을 입력해주세요",
        text: $store.eventTitle
      )
      .font(.system(size: 24, weight: .regular))
      .padding(.horizontal, PND.Metrics.defaultSpacing)
      .tint(PND.DS.primary)
      
      Spacer().frame(height: 20)
      
      Text("상세설명")
        .padding(.leading, PND.Metrics.defaultSpacing)
        .font(.system(size: 16, weight: .bold))
      
      Spacer().frame(height: 12)
      
      TextEditorWithPlaceholder(
        text: $store.eventDescription,
        placeholder: "이벤트에 대해 좀 더 자세히 설명해주세요.\nex) 반려동물 종류, 주요활동 내용, 활동 지역, 활동 주기 등"
      )
      .padding(.horizontal, PND.Metrics.defaultSpacing)
      .frame(height: UIScreen.fixedScreenSize.height / 3)
      
      SelectImagesHorizontalView(
        maxImagesCount: 1,
        selectedImageDatas: $store.selectedImageDatas
      )
      
      Spacer()
      
      
      BaseBottomButton_SwiftUI(
        title: "작성 완료",
        isEnabled: $store.isBottomButtonEnabled
      )
      .onTapGesture {
        store.send(.onBottomButtonTap)
      }

    }
  }
}

#Preview {
  WriteEventDescriptionView(store: .init(initialState: .init(eventUploadModel: .init()), reducer: { WriteEventDescriptionFeature() }))
}
