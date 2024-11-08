//
//  SelectAddressDetailView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 11/7/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SelectAddressDetailFeature: Reducer {
  
  @ObservableState
  struct State: Equatable {
    
    var eventUploadModel: PND.EventUploadModel
    
    var addressDetail: String = ""
    var isBottomButtonEnabled: Bool = false
  }
  
  enum Action: BindableAction {
    case onBottomButtonTap
    case pushToWriteEventDescription(eventUploadModel: PND.EventUploadModel)
    case binding(BindingAction<State>)
  }
  
  var body: some Reducer<State,Action> {
    BindingReducer()
    Reduce { state, action in
      
      switch action {
        
      case .onBottomButtonTap:
        var eventUploadModel = state.eventUploadModel
        eventUploadModel.eventAddressDetail = state.addressDetail
        return .send(.pushToWriteEventDescription(eventUploadModel: eventUploadModel))
        
      case .binding(\.addressDetail):
        state.isBottomButtonEnabled = state.addressDetail.isEmpty ? false : true
        return .none
        
      default:
        return .none
      }
      
      return .none
    }
  }
}

struct SelectAddressDetailView: View {
  
  @State var store: StoreOf<SelectAddressDetailFeature>
  
  var body: some View {
    VStack(spacing: 0) {
      
      NaverMap()
      
      VStack(alignment: .leading, spacing: 0) {
        
        Spacer().frame(height: 20)
        
        Text("서울 종로구 세종대로 209")
          .font(.system(size: 14, weight: .bold))
          .foregroundStyle(PND.DS.commonBlack)
        
        Spacer().frame(height: 4)
        
        Text("[지번] 서울 종로구 세종로 88-4")
          .font(.system(size: 14, weight: .medium))
          .foregroundStyle(PND.DS.gray50)
        
        Spacer().frame(height: 16)
        
        TextField("상세주소를 입력해주세요", text: $store.addressDetail)
          .tint(.black)
          .frame(height: 42)
          .padding(.horizontal, 10)
          .clipShape(RoundedRectangle(cornerRadius: CGFloat(4)))
          .overlay(
            RoundedRectangle(cornerRadius: CGFloat(4))
              .inset(by: 0.5)
              .stroke(PND.DS.commonGrey, lineWidth: 1)
          )

        
        Spacer().frame(height: 90)
      }
      .padding(.horizontal, PND.Metrics.defaultSpacing)
      
      
      BaseBottomButton_SwiftUI(
        title: "다음 단계로",
        isEnabled: $store.isBottomButtonEnabled
      )
      .onTapGesture {
        store.send(.onBottomButtonTap)
      }
      
    }
    .navigationTitle("주소 상세 정보 입력")
  }
}

//#Preview {
//  SelectAddressDetailView(store: .init(initialState: .init(), reducer: { SelectAddressDetailFeature() }))
//}
