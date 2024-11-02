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
    
    // 이벤트 종류
    var isEventDurationPickerFocused: Bool = true
    var eventDuration: EventDuration? = nil
    
    // 날짜 시간
    var isDatePickerExpanded: Bool = false
    var isDatePickerFocused: Bool = false
    var dateChangedByUser: Bool = false
    var date: Date = .init()
    
    // 이벤트 주제
  
    var isSubjectPickerExpanded: Bool = false
    var isSubjectPickerFocused: Bool = false
    var subject: String? = nil
    
    
    // 참여 인원
    var isParticipantsPickerExpanded: Bool = false
    var isParticipantsPickerFocused: Bool = false
    var participants: Int = 0
    
    
    // 참여 비용
    var isFeePickerExpanded: Bool = false
    var isFeePickerFocused: Bool = false
    var fee: Int = 0
    var feeTextFieldText: String = ""
    
    var isBottomButtonEnabled: Bool = false
  }
  
  enum Action: BindableAction {
    
    case onEventDurationChange(EventDuration)
    case onDateChange
    
    case onEventSubjectPickerTap
    case onEventSubjectChange(String)
    
    
    case onMinusParticipants
    case onPlusParticipants
    
    case onFeePickerTap
    

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
        state.dateChangedByUser = true
        return .none
        
      case .onEventSubjectPickerTap:
        state.isDatePickerFocused = false
        state.isSubjectPickerFocused = true
        return .none
        
        
      case .onEventSubjectChange(let subject):
        state.isSubjectPickerFocused = false
        state.isParticipantsPickerFocused = true
        state.subject = subject
        return .none
        
      case .onPlusParticipants:
        state.participants += 1
        return .none
        
      case .onMinusParticipants:
        if state.participants <= 0 {
          return .none
        }
        
        state.participants -= 1
        return .none
        
      case .onFeePickerTap:
        guard state.participants >= 1 else { return .none }
        state.isParticipantsPickerFocused = false
        state.isFeePickerFocused = true
        return .none
        
      case .binding(\.feeTextFieldText):
//        state.feeTextFieldText = "\(state.feeTextFieldText)원"
        
        let digits = state.feeTextFieldText
          .components(separatedBy: CharacterSet.decimalDigits.inverted)
          .joined()
        
        if let price = Int(digits) {
          state.fee = price
          
          if price > 0 {
            state.isBottomButtonEnabled = true
//            state.feeTextFieldText = "\(price)원"
          }
        }
        
        
     
        
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
    VStack() {
      
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
      
      BaseBottomButton_SwiftUI(
        title: "다음 단계로",
        isEnabled: $store.isBottomButtonEnabled
      )
    }

    .background(PND.DS.gray10)
  }
  
  @ViewBuilder
  private func numberTextView(
    number: String,
    isFocused: Bool
  ) -> some View {
    Text(number)
      .foregroundStyle(.white)
      .padding(.horizontal, 8)
      .padding(.vertical, 4)
      .background(isFocused ? PND.DS.primary : PND.DS.gray30)
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
      numberTextView(number: "1", isFocused: (store.isEventDurationPickerFocused || store.eventDuration != nil))
      
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
          numberTextView(number: "2", isFocused: (store.isDatePickerFocused || store.dateChangedByUser))
          
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
    .allowsHitTesting(store.eventDuration != nil)
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
          numberTextView(number: "3", isFocused: (store.isSubjectPickerFocused || store.subject != nil))
            
          
          settingsTypeTitleView(title: "이벤트 주제")
          
          Spacer()
          
          if let subject = store.subject {
            Text(subject)
              .font(.system(size: 14, weight: .bold))
              .foregroundStyle(PND.DS.primary)
              .padding(.vertical, 8)
              .padding(.horizontal, 12)
              .background(PND.DS.lightGreen)
              .clipShape(Capsule())
            
          } else {
            Text("이벤트 종류를 선택하세요")
              .font(.system(size: 14, weight: .bold))
              .foregroundStyle(PND.DS.gray50)
              .padding(.vertical, 8)
              .padding(.horizontal, 12)
              .background(PND.DS.gray10)
              .clipShape(Capsule())
          }
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
                .onTapGesture {
                  store.send(.onEventSubjectChange("산책"))
                }
              }
          }
          .frame(width: totalWidth)
        }
      }
    )
    .onTapGesture {
      store.send(.onEventSubjectPickerTap)
    }
  }
  
  
  // 참여인원
  @ViewBuilder
  private var participantPickerView: some View {
    ExpandableView(
      isExpanded: $store.isParticipantsPickerExpanded,
      isFocused: $store.isParticipantsPickerFocused,
      thumbnail: ThumbnailView {
        HStack {
          numberTextView(number: "4", isFocused: (store.isParticipantsPickerFocused || store.participants >= 1))
            
          settingsTypeTitleView(title: "최소 참여인원")
          
          Spacer()
          
          HStack(spacing: 8) {
            
            Image(systemName: "minus")
              .resizable()
              .frame(width: 8, height: 2)
              .padding(.horizontal, 4)
              .padding(.vertical, 7)
              .background(store.participants >= 1 ? PND.DS.primary : PND.DS.gray30)
              .foregroundStyle(PND.DS.commonWhite)
              .clipShape(Circle())
              .onTapGesture {
                store.send(.onMinusParticipants)
              }
            
            Text("\(store.participants)")
              .foregroundStyle(store.participants >= 1 ? PND.DS.primary : PND.DS.gray50)
              .font(.system(size: 14, weight: .bold))
            
            Image(systemName: "plus")
              .resizable()
              .frame(width: 8, height: 8)
              .padding(.horizontal, 4)
              .padding(.vertical, 7)
              .background(store.participants >= 1 ? PND.DS.primary : PND.DS.gray30)
              .foregroundStyle(PND.DS.commonWhite)
              .clipShape(Circle())
              .onTapGesture {
                store.send(.onPlusParticipants)
              }
             
          }
          .padding(.horizontal, 12)
          .padding(.vertical, 8)
          .background(store.participants >= 1 ? PND.DS.lightGreen : PND.DS.gray10)
          .clipShape(Capsule())
        }
      },
      expanded: ExpandedView {
        Rectangle().frame(height: 0)
      }
    )
    .allowsHitTesting(store.subject != nil)
  }
  
  // 참여비용
  @ViewBuilder
  private var feePickerView: some View {
    ExpandableView(
      isExpanded: $store.isFeePickerExpanded,
      isFocused: $store.isFeePickerFocused,
      thumbnail: ThumbnailView {
        HStack {
          numberTextView(number: "5", isFocused: store.isFeePickerFocused)
          settingsTypeTitleView(title: "참여 비용")
          Spacer()
          
          TextField(
            "",
            text: $store.feeTextFieldText,
            prompt: Text("참여비용을 입력하세요")
              .foregroundStyle(PND.DS.gray50)
              .font(.system(size: 14))
              .fontWeight(.bold)
          )
          .keyboardType(.numberPad)
          .tint(PND.DS.primary)
          .padding(.horizontal, 12)
          .padding(.vertical, 8)
          .font(.system(size: 14, weight: .bold))
          .background(Int(store.feeTextFieldText) ?? 0 > 0 ? PND.DS.lightGreen : PND.DS.gray10)
          .foregroundStyle(PND.DS.primary)
          .clipShape(Capsule())

        }
      },
      expanded: ExpandedView {
        Rectangle().frame(height: 0)
      }
    )
    .allowsHitTesting(store.participants >= 1)
    .onTapGesture {
      store.send(.onFeePickerTap)
    }
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
