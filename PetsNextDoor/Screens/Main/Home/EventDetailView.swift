//
//  EventDetailView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 9/6/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct EventDetailFeature: Reducer {
  
  @ObservableState
  struct State: Equatable {
    
  }
  
  enum Action: RestrictiveAction, BindableAction {
    
    enum ViewAction: Equatable {
      
    }
    
    enum InternalAction: Equatable {
      
    }
    
    enum DelegateAction: Equatable {
      
    }
    
    case view(ViewAction)
    case delegate(DelegateAction)
    case `internal`(InternalAction)
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

struct EventDetailView: View {
  
  @State var store: StoreOf<EventDetailFeature>
  
  var body: some View {
    ZStack() {
     
      VStack(alignment: .leading) {
        KFImage.url(MockDataProvider.randomePetImageUrl)
          .placeholder { ProgressView() }
          .resizable()
          .frame(width: UIScreen.fixedScreenSize.width, height: 165)
        
        Spacer().frame(height: 20)
        
        // 이벤트명
        Text("훈련사님과 함께하는 멍BTI 진단하기")
          .lineLimit(2)
          .font(.system(size: 24, weight: .bold))
          .multilineTextAlignment(.leading)
          .padding(.horizontal, PND.Metrics.defaultSpacing)
        
        Spacer().frame(height: 8)
        
        eventInfoView
          .padding(.horizontal, PND.Metrics.defaultSpacing)
        
        Spacer().frame(height: 16)
        
        Text("돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명 돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명 모임에 대해서 상세한 설명돌봄모임에 대해서")
          .font(.system(size: 14, weight: .regular))
          .padding(.horizontal, PND.Metrics.defaultSpacing)
        
        Spacer().frame(height: 28)
        
        eventDateAndLocationView
          .padding(.horizontal, PND.Metrics.defaultSpacing)
        
        Spacer()
      }
      

      topNavigationBar
        .padding(.horizontal, PND.Metrics.defaultSpacing)

    }
    .ignoresSafeArea(.all)
  }
  
  @ViewBuilder
  private var topNavigationBar: some View {
    VStack {
      HStack() {
        Button {
          
        } label: {
          Image(.iconUndo)
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(PND.DS.commonWhite)
        }
        
        Spacer()
        
        Button {
          
        } label: {
          Image(.iconMenu)
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(PND.DS.commonWhite)
        }
      }
      Spacer()
    }
  }
  
  @ViewBuilder
  private var eventInfoView: some View {
    HStack(spacing: 0) {
      KFImage.url(MockDataProvider.randomePetImageUrl)
        .resizable()
        .scaledToFit()
        .frame(width: 16, height: 16)
        .clipShape(.circle)
      
      Spacer().frame(width: 5)
      
      Text("아롱맘 • 염창1동")
        .font(.system(size: 12, weight: .medium))
      
      Spacer().frame(width: 5)
      
      Image(.iconPin)
        .resizable()
        .frame(width: 16, height: 16)
      
      Spacer().frame(width: 2)
      
      Text("서울 강서구")
        .font(.system(size: 12, weight: .medium))
      
      Spacer().frame(width: 7)
      
      Image(.iconGroup)
        .resizable()
        .frame(width: 16, height: 16)
      
      Spacer().frame(width: 5)
      
      Text("6/10")
        .font(.system(size: 12, weight: .medium))
    }
  }
  
  @ViewBuilder
  private var eventDateAndLocationView: some View {
    let availableSpace = UIScreen.fixedScreenSize.width - (PND.Metrics.defaultSpacing * 2) - CGFloat(12)
    HStack(spacing: 12) {
      
      // 이벤트 날짜
      VStack(alignment: .leading, spacing: 4) {
        Image(.iconCalendar)
          .renderingMode(.template)
          .resizable()
          .frame(width: 24, height: 24)
          .foregroundStyle(PND.DS.commonBlack)
        
        Text("2024.09.15")
          .font(.system(size: 14, weight: .bold))
          .lineLimit(1)
        
        Text("10:00 - 13:00")
          .font(.system(size: 12, weight: .regular))
          .lineLimit(1)
      }
      .padding(.all, 12)
      .background(
        RoundedRectangle(cornerRadius: 10)
          .strokeBorder(Color(uiColor: .init(hex: "#EBEBEB")), lineWidth: 1)
      )
      .frame(width: availableSpace / 2)
      
      // 이벤트 장소
      VStack(alignment: .leading, spacing: 4) {
        Image(.iconPinLine)
          .renderingMode(.template)
          .resizable()
          .frame(width: 24, height: 24)
          .foregroundStyle(PND.DS.commonBlack)
        
        Text("서울시 강서구 멍냥로")
          .font(.system(size: 14, weight: .bold))
          .lineLimit(1)
        
        Text("12-5")
          .font(.system(size: 12, weight: .regular))
          .lineLimit(1)
      }
      .padding(.all, 12)
      .background(
        RoundedRectangle(cornerRadius: 10)
          .strokeBorder(Color(uiColor: .init(hex: "#EBEBEB")), lineWidth: 1)
      )
      .frame(width: availableSpace / 2)
    }
//    .frame(width: UIScreen.fixedScreenSize.width - (PND.Metrics.defaultSpacing * 2))
  }
}

//#Preview {
//  EventDetailView()
//}
