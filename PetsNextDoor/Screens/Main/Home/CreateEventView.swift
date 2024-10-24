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
    
    var isEventTypePickerExpanded: Bool = false
    var isDatePickerExpanded: Bool = false
    var isSubjectPickerExpanded: Bool = false
    var isParticipantsPickerExpanded: Bool = false
    var isFeePickerExpanded: Bool = false
  }
  
  enum Action: BindableAction {
    
    case binding(BindingAction<State>)
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
        
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
      VStack(spacing: 15){
        
        eventTypePickerView
        datePickerView
        eventSubjectPickerView
        participantPickerView
        feePickerView
        
      }
    }
    .scrollIndicators(.never)
  }
  
  // 이벤트 종류
  @ViewBuilder
  private var eventTypePickerView: some View {
    ExpandableView(
      isExpanded: $store.isEventTypePickerExpanded,
      thumbnail: ThumbnailView {
        HStack {
          Text("1")
            .foregroundStyle(.white)
            .padding(10)
            .background(PND.DS.primary)
            .clipShape(Circle())
          
          
          Text("이벤트 종류")
            .font(.system(size: 16, weight: .bold))
          
          Spacer()
          
          Text("단기 이벤트")
            .foregroundStyle(PND.DS.primary)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(PND.DS.lightGreen)
            .clipShape(Capsule())
        }
        .frame(width: UIScreen.fixedScreenSize.width - (PND.Metrics.defaultSpacing * 2))
        .padding(.horizontal)
        .padding(.vertical)
      },
      expanded: ExpandedView {
        Text("이벤트 종류")
      }
    )
  }
  
  
  // 날짜/시간
  @ViewBuilder
  private var datePickerView: some View {
    ExpandableView(
      isExpanded: $store.isDatePickerExpanded,
      thumbnail: ThumbnailView {
        HStack {
          Text("2")
            .foregroundStyle(.white)
            .padding(10)
            .background(PND.DS.primary)
            .clipShape(Circle())
            
          
          Text("날짜/시간")
            .font(.system(size: 16, weight: .bold))
          
          Spacer()
          
          HStack(spacing: 5) {
            Text("2024.10.24")
              .fontWeight(.medium)
              .font(.system(size: 14))
              .minimumScaleFactor(0.7)
            
            Image(systemName: "chevron.down")
          }
          .padding(.vertical, 5)
          .padding(.horizontal, 10)
          .foregroundStyle(PND.DS.gray50)
          .background(PND.DS.gray10)
          .clipShape(Capsule())
          
          Spacer().frame(width: 5)
            
          HStack(spacing: 5) {
            Text("00:00")
              .fontWeight(.medium)
              .font(.system(size: 14))
              .minimumScaleFactor(0.7)
            
            Image(systemName: "chevron.down")
          }
          .padding(.vertical, 5)
          .padding(.horizontal, 10)
          .foregroundStyle(PND.DS.gray50)
          .background(PND.DS.gray10)
          .clipShape(Capsule())
         
        }
        .frame(width: UIScreen.fixedScreenSize.width - (PND.Metrics.defaultSpacing * 2))
        .padding(.horizontal)
        .padding(.vertical)
      },
      expanded: ExpandedView {
        Text("이벤트 종류")
      }
    )
  }
  
  // 이벤트 종류
  @ViewBuilder
  private var eventSubjectPickerView: some View {
    ExpandableView(
      isExpanded: $store.isSubjectPickerExpanded,
      thumbnail: ThumbnailView {
        HStack {
          Text("3")
            .foregroundStyle(.white)
            .padding(10)
            .background(PND.DS.primary)
            .clipShape(Circle())
            
          
          Text("이벤트 주제")
            .font(.system(size: 16, weight: .bold))
          
          Spacer()
          
          Text("산책")
            .font(.system(size: 16, weight: .bold))
         
        }
        .frame(width: UIScreen.fixedScreenSize.width - (PND.Metrics.defaultSpacing * 2))
        .padding(.horizontal)
        .padding(.vertical)
      },
      expanded: ExpandedView {
        Text("이벤트 종류")
      }
    )
  }
  
  
  // 참여인원
  @ViewBuilder
  private var participantPickerView: some View {
    ExpandableView(
      isExpanded: $store.isParticipantsPickerExpanded,
      thumbnail: ThumbnailView {
        HStack {
          Text("4")
            .foregroundStyle(.white)
            .padding(10)
            .background(PND.DS.primary)
            .clipShape(Circle())
            
          
          Text("참여 인원")
            .font(.system(size: 16, weight: .bold))
          
          Spacer()
          
          Text("3명")
            .font(.system(size: 16, weight: .bold))
         
        }
        .frame(width: UIScreen.fixedScreenSize.width - (PND.Metrics.defaultSpacing * 2))
        .padding(.horizontal)
        .padding(.vertical)
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
      thumbnail: ThumbnailView {
        HStack {
          Text("5")
            .foregroundStyle(.white)
            .padding(10)
            .background(PND.DS.primary)
            .clipShape(Circle())
            
          
          Text("참여 인원")
            .font(.system(size: 16, weight: .bold))
          
          Spacer()
          
          Text("3,000원")
            .font(.system(size: 16, weight: .bold))
         
        }
        .frame(width: UIScreen.fixedScreenSize.width - (PND.Metrics.defaultSpacing * 2))
        .padding(.horizontal)
        .padding(.vertical)
      },
      expanded: ExpandedView {
        Text("이벤트 종류")
      }
    )
  }
  
  
  
  
  
  @ViewBuilder
  private func subjectButtonView(title: String) -> some View {
    Button(action: {

    }, label: {
      ZStack {
        Rectangle()
          .fill(Color.blue)
          .aspectRatio(1, contentMode: .fit)
        
        Text(title)
          .cornerRadius(4)
          .foregroundStyle(.foreground)
          .multilineTextAlignment(.center)
          .font(.system(size: 14, weight: .medium))
          .minimumScaleFactor(0.8)
      }
    })
  }
}

#Preview {
  CreateEventView(store: .init(initialState: .init(), reducer: { CreateEventFeature() }))
}
