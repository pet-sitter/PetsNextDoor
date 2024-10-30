//
//  CreateEventView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 10/24/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CreateEventFeature: Reducer {
  
  @ObservableState
  struct State: Equatable {
    var eventDuration: EventDuration? = nil
    
    var isDatePickerExpanded: Bool = false
    var isDatePickerFocused: Bool = false
    var date: Date = .init()
    
    var isSubjectPickerExpanded: Bool = false
    var isSubjectPickerFocused: Bool = false
    
    var isParticipantsPickerExpanded: Bool = false
    var isParticipantsPickerFocused: Bool = false
    
    var isFeePickerExpanded: Bool = false
    var isFeePickerFocused: Bool = false
  }
  
  enum Action: BindableAction {
    
    case onEventDurationChange(EventDuration)
    case onDateChange
    
    case binding(BindingAction<State>)
  }
  
  enum EventDuration: String {
    case daily    = "매일"
    case weekly   = "매주"
    case biWeekly = "2주에 한 번"
    case monthly  = "매달"
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
        
      case .onEventDurationChange(let duration):
        state.eventDuration = duration
        state.isDatePickerFocused = true
        return .none
        
      case .onDateChange:
        state.isSubjectPickerFocused = true
        return .none
        
      default:
        return .none
      }
    }
  }
}

import Kingfisher
import SwiftUI

struct CreateEventView: View {
  
  @State var store: StoreOf<CreateEventFeature>
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 15) {
        
        Text("정기 이벤트")
          .padding(.horizontal, 12)
          .padding(.vertical, 8)
          .background(PND.DS.lightGreen)
          .clipShape(Capsule())
          .foregroundStyle(PND.DS.primary)
          .font(.system(size: 14, weight: .bold))
          .padding(.leading, PND.Metrics.defaultSpacing)
        
        eventDurationTypePickerView
        
        datePickerView
          
        eventSubjectPickerView
        
        participantPickerView
        
        feePickerView
  
      }

    }
    .scrollIndicators(.never)
    .background(PND.DS.gray10)
  }
  
  @ViewBuilder
  private func numberTextView(number: String) -> some View {
    Text(number)
      .foregroundStyle(.white)
      .padding(.horizontal, 8)
      .padding(.vertical, 4)
      .background(PND.DS.primary)
      .clipShape(Circle())
      .font(.system(size: 14, weight: .bold))
  }
  
  @ViewBuilder
  private func settingsTypeTitleView(title: String) -> some View {
    Text(title)
      .font(.system(size: 16, weight: .bold))
  }

  
  // 이벤트 종류
  @ViewBuilder
  private var eventDurationTypePickerView: some View {
    HStack(spacing: 0) {
      numberTextView(number: "1")
      
      Spacer().frame(width: 8)
      
      settingsTypeTitleView(title: "이벤트 종류")
      
      Spacer()
      
      Menu {
        Button {
          store.send(.onEventDurationChange(.daily))
        } label: {
          HStack {
            Text(CreateEventFeature.EventDuration.daily.rawValue)
            if store.eventDuration == .daily {
              Image(systemName: "checkmark")
            }
          }
        }
        
        Button {
          store.send(.onEventDurationChange(.weekly))
        } label: {
          HStack {
            Text(CreateEventFeature.EventDuration.weekly.rawValue)
            if store.eventDuration == .weekly {
              Image(systemName: "checkmark")
            }
          }
        }
        
        Button {
          store.send(.onEventDurationChange(.biWeekly))
        } label: {
          HStack {
            Text(CreateEventFeature.EventDuration.biWeekly.rawValue)
            if store.eventDuration == .biWeekly {
              Image(systemName: "checkmark")
            }
          }
        }
        
        
        Button {
          store.send(.onEventDurationChange(.monthly))
        } label: {
          HStack {
            Text(CreateEventFeature.EventDuration.monthly.rawValue)
            if store.eventDuration == .monthly {
              Image(systemName: "checkmark")
            }
          }
        }

      } label: {
        if let eventDuration = store.eventDuration {
          Text(eventDuration.rawValue)
            .font(.system(size: 14, weight: .bold))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(PND.DS.lightGreen)
            .foregroundStyle(PND.DS.primary)
            .clipShape(Capsule())
        } else {
          HStack(spacing: 5) {
            Text("이벤트 주기를 선택하세요")
              .fontWeight(.medium)
              .font(.system(size: 14))
              .minimumScaleFactor(0.7)
            
            Image(systemName: "chevron.down")
              .resizable()
              .renderingMode(.template)
              .frame(width: 8, height: 5)
          }
          .padding(.vertical, 5)
          .padding(.horizontal, 10)
          .foregroundStyle(PND.DS.gray50)
          .background(PND.DS.gray10)
          .clipShape(Capsule())
        }
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 20)
    .background(PND.DS.commonWhite)
    .cornerRadius(8)
    .padding(.horizontal, PND.Metrics.defaultSpacing)
    .if(store.eventDuration == nil, { view in
      view
        .modifier(RoundedRectangleStrokeOverlayModifier())
    })
  }
  
  
  // 날짜/시간
  @ViewBuilder
  private var datePickerView: some View {
    ExpandableView(
      isExpanded: $store.isDatePickerExpanded,
      isFocused: $store.isDatePickerFocused,
      thumbnail: ThumbnailView {
        HStack {
          numberTextView(number: "2")
          
          settingsTypeTitleView(title: "날짜/시간")
          
          Spacer()
          
          DatePicker(
            selection: $store.date,
            in: Date()...,
            displayedComponents: [.date, .hourAndMinute]
          ) {}
            .tint(PND.DS.primary)
            .onChange(of: store.date) { _, _ in
              store.send(.onDateChange)
            }
        }
      },
      expanded: ExpandedView {
        VStack(spacing: 0) {
          Spacer().frame(height: 15)
          Group {
            Text("정기 이벤트를 만들기 위해 ")
         
            + Text("첫 모임 날짜와 시간")
              .foregroundStyle(PND.DS.primary)
            + Text("을 설정하세요.")
          }
          .font(.system(size: 12, weight: .semibold))
          .frame(maxWidth: .infinity, alignment: .leading)
        }

      }
    )
  }
  
  // 이벤트 종류
  @ViewBuilder
  private var eventSubjectPickerView: some View {
    let totalWidth: CGFloat = UIScreen.fixedScreenSize.width - (PND.Metrics.defaultSpacing * 2) - (15 * 2)
    let squareSize: CGFloat = totalWidth  / 4
    
    ExpandableView(
      isExpanded: $store.isSubjectPickerExpanded,
      isFocused: $store.isSubjectPickerFocused,
      thumbnail: ThumbnailView {
        HStack {
          numberTextView(number: "3")
            
          
          settingsTypeTitleView(title: "이벤트 주제")
          
          Spacer()
          
          Text("이벤트 종류를 선택하세요")
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(PND.DS.gray50)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(PND.DS.gray10)
            .clipShape(Capsule())
         
        }


      },
      expanded: ExpandedView {
        VStack(spacing: 8) {
          HStack(spacing: 8) {
              ForEach(0..<4) { _ in
                ZStack {
                  Rectangle()
                      .fill(Color.gray)
                }
                .frame(width: squareSize, height: squareSize)
              }
          }
          .frame(width: totalWidth)
          
          HStack(spacing: 8) {
              ForEach(0..<4) { _ in
                ZStack {
                  Rectangle()
                      .fill(Color.gray)
                  
                  Text("산책")
                }
                .frame(width: squareSize, height: squareSize)
              }
          }
          .frame(width: totalWidth)
        }
      }
    )
  }
  
  
  // 참여인원
  @ViewBuilder
  private var participantPickerView: some View {
    ExpandableView(
      isExpanded: $store.isParticipantsPickerExpanded,
      isFocused: $store.isParticipantsPickerFocused,
      thumbnail: ThumbnailView {
        HStack {
          numberTextView(number: "4")
            
          
          settingsTypeTitleView(title: "최소 참여인원")
          
          Spacer()
          
          Text("3명")
            .font(.system(size: 16, weight: .bold))
         
        }

      },
      expanded: ExpandedView {
        Text("이벤트 종류")
      }
    )
  }
  
  // 참여비용
  @ViewBuilder
  private var feePickerView: some View {
    ExpandableView(
      isExpanded: $store.isFeePickerExpanded,
      isFocused: $store.isFeePickerFocused,
      thumbnail: ThumbnailView {
        HStack {
          numberTextView(number: "5")
          settingsTypeTitleView(title: "참여 비용")
          Spacer()
          Text("3,000원")
            .font(.system(size: 16, weight: .bold))
        }
      },
      expanded: ExpandedView {
        Text("이벤트 종류")
      }
    )
  }
}

fileprivate struct RoundedRectangleStrokeOverlayModifier: ViewModifier {
  
  func body(content: Content) -> some View {
    content
      .overlay {
        RoundedRectangle(cornerRadius: 8)
          .inset(by: 0.5)
          .stroke(PND.DS.primary, lineWidth: 1)
          .padding(.horizontal, PND.Metrics.defaultSpacing)
      }
  }
}

#Preview {
  CreateEventView(store: .init(initialState: .init(), reducer: { CreateEventFeature() }))
}
