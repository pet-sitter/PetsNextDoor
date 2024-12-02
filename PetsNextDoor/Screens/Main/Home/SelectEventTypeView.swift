//
//  SelectEventTypeView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 11/2/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SelectEventTypeFeature {
  
  @ObservableState
  struct State: Equatable {
    var isInitialState: Bool = true
    var selectedEventType: PND.EventType? = nil
    var isBottomButtonEnabled: Bool = false
  }
  
  enum Action: BindableAction {
    case onSelectSingleEventType
    case onSelectRegularEventType
    case onSelectBottomButton
    case pushToCreateEventView(eventUploadModel: PND.EventUploadModel)
    case binding(BindingAction<State>)
  }

  var body: some Reducer<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
        
      case .onSelectSingleEventType:
        state.isInitialState = false
        state.selectedEventType = .shortTerm
        state.isBottomButtonEnabled = true
        return .none
        
      case .onSelectRegularEventType:
        state.isInitialState = false
        state.selectedEventType = .recurring
        state.isBottomButtonEnabled = true
        return .none
        
      case .onSelectBottomButton:
        if let selectedEventType = state.selectedEventType {
          var eventUploadModel = PND.EventUploadModel()
          eventUploadModel.eventType = selectedEventType
          
          return .send(.pushToCreateEventView(eventUploadModel: eventUploadModel))
        } else {
          return .none
        }
        
      default:
        return .none
      }
    }
  }
  
}


struct SelectEventTypeView: View {
  
  @State var store: StoreOf<SelectEventTypeFeature>
  
  private var squareWidth: CGFloat {
    (UIScreen.fixedScreenSize.width - (PND.Metrics.defaultSpacing * 2) - 8) / 2
  }
  
  private var singleEventFontColor: Color {
    if store.isInitialState {
      return PND.DS.commonBlack
    } else {
      return store.selectedEventType == .shortTerm ? PND.DS.commonBlack : PND.DS.gray50
    }
  }
  
  private var singleEventImage: Image {
    if store.isInitialState {
      return Image(.eventCalendar)
    } else {
      return store.selectedEventType == .shortTerm ? Image(.eventCalendar) : Image(.eventCalendarDisabled)
    }
  }
  
  private var recurringEventImage: Image {
    if store.isInitialState {
      return Image(.regularEventCalendar)
    } else {
      return store.selectedEventType == .recurring ? Image(.regularEventCalendar) : Image(.regularEventCalendarDisabled)
    }
  }
  
  private var recurringEventFontColor: Color {
    if store.isInitialState {
      return PND.DS.commonBlack
    } else {
      return store.selectedEventType == .recurring ? PND.DS.commonBlack : PND.DS.gray50
    }
  }
  
  
  var body: some View {
    VStack() {
      Text("먼저 이벤트 타입을 선택해주세요")
        .font(.system(size: 20, weight: .bold))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, PND.Metrics.defaultSpacing)
      
      Spacer().frame(height: 12)
      
      HStack(spacing: 8) {
        ZStack {
          VStack(spacing: 0) {
            Group {
              Text(PND.EventType.shortTerm.description)
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
              
              Text("하루만 진행되는\n일회성 모임입니다.")
                .font(.system(size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundStyle(singleEventFontColor)
            
            singleEventImage
              .frame(maxWidth: .infinity, alignment: .trailing)
          }
          .padding(.horizontal, 16)
        }
        .frame(width: squareWidth, height: squareWidth)
        .background(PND.DS.commonWhite)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .if(store.selectedEventType == .shortTerm, { view in
          view
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(PND.DS.primary, lineWidth: 1.0)
            )
        })

        .onTapGesture {
          store.send(.onSelectSingleEventType)
        }
        
        ZStack {
          VStack(spacing: 0) {
            
            Group {
              Text(PND.EventType.recurring.description)
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
              
              Text("주기적으로 반복되는\n모임입니다.")
                .font(.system(size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundStyle(recurringEventFontColor)

            
            recurringEventImage
              .frame(maxWidth: .infinity, alignment: .trailing)
          }
          .padding(.horizontal, 16)
        }
        .frame(width: squareWidth, height: squareWidth)
        .background(PND.DS.commonWhite)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .if(store.selectedEventType == .recurring, { view in
          view
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(PND.DS.primary, lineWidth: 1.0)
            )
        })
        .onTapGesture {
          store.send(.onSelectRegularEventType)
        }
      }

      Spacer()
      
      
      BaseBottomButton_SwiftUI(
        title: "다음 단계로",
        isEnabled: $store.isBottomButtonEnabled
      )
      .onTapGesture {
        store.send(.onSelectBottomButton)
      }
        
    }
    .background(PND.DS.gray10)
  }
}

#Preview {
  SelectEventTypeView(store: .init(initialState: .init(), reducer: { SelectEventTypeFeature() }))
}
