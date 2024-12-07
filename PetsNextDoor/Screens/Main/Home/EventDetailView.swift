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
      case onBackButtonTap
    }
    
    enum InternalAction: Equatable {
      
    }
    
    enum DelegateAction: Equatable {
      case popView
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
        
      case .view(.onBackButtonTap):
        return .send(.delegate(.popView))
        
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
      ScrollView(.vertical) {
        VStack(alignment: .leading) {
          
          KFImage.url(MockDataProvider.randomePetImageUrl)
            .placeholder { ProgressView() }
            .resizable()
            .frame(width: UIScreen.fixedScreenSize.width, height: UIScreen.fixedScreenSize.height / 4)
       
          
          Spacer().frame(height: 20)
          
          // 이벤트 종류, 이벤트 태그, 참여 인원
          eventInfoTagView
          
          Spacer().frame(height: 12)
          
          // 이벤트명
          Text("훈련사님과 함께하는 멍BTI 진단하기")
            .lineLimit(2)
            .font(.system(size: 24, weight: .bold))
            .multilineTextAlignment(.leading)
            .padding(.horizontal, PND.Metrics.defaultSpacing)
          
          Spacer().frame(height: 8)
          
          authorView
            .padding(.horizontal, PND.Metrics.defaultSpacing)
          
          Spacer().frame(height: 8)
          
          Text("돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명 돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대")
            .font(.system(size: 14, weight: .regular))
            .padding(.horizontal, PND.Metrics.defaultSpacing)
            .lineSpacing(5)
            
          
          Spacer().frame(height: 28)
          
          eventDateAndFeeView
            .padding(.horizontal, PND.Metrics.defaultSpacing)
          
          eventLocationView
            .padding(.horizontal, PND.Metrics.defaultSpacing)
          
          Spacer().frame(height: 8)
          
          eventProgressView
          
          
          
          Spacer()
        }
      
      }
     
      joinChatArea

    }
    .ignoresSafeArea(.all)
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button {
          store.send(.view(.onBackButtonTap))
        } label: {
          Image(.iconUndo)
            .renderingMode(.template)
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(PND.DS.commonWhite)
        }
      }
      
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          
        } label: {
          Image(.iconMenu)
            .renderingMode(.template)
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(PND.DS.commonWhite)
        }
      }
    }
    
  }
  
  @ViewBuilder
  private var eventInfoTagView: some View {
    Group {
      HStack(spacing: 0) {
        Text("단기 이벤트")
          .padding(.horizontal, 12)
          .padding(.vertical, 8)
          .background(PND.DS.gray20)
          .clipShape(Capsule())
        
        Spacer().frame(width: 4)
         
        
        Text("산책")
          .padding(.horizontal, 12)
          .padding(.vertical, 8)
          .background(PND.DS.gray20)
          .clipShape(Capsule())
        
        Spacer()
        
        HStack {
          Image(.iconGroup)
            .resizable()
            .frame(width: 16, height: 16)
          
          Text("6/10")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(PND.DS.gray20)
        .clipShape(Capsule())

      }
    }
    .font(.system(size: 14, weight: .medium))
    .padding(.horizontal, PND.Metrics.defaultSpacing)
  }
  
  
  @ViewBuilder
  private var authorView: some View {
    HStack(spacing: 0) {
      KFImage.url(MockDataProvider.randomePetImageUrl)
        .placeholder {
          ProgressView()
        }
        .resizable()
        .scaledToFit()
        .frame(width: 16, height: 16)
        .clipShape(.circle)
      
      Spacer().frame(width: 5)
      
      Text("아롱맘")
        .font(.system(size: 12, weight: .medium))
    }
  }
  
  @ViewBuilder
  private var eventDateAndFeeView: some View {
    HStack(spacing: 12) {

      // 이벤트 날짜
      HStack(spacing: 0) {
        Spacer().frame(width: 12)
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
        .padding(.vertical, 12)
        
        Spacer(minLength: 12)
      }
      .background(
        RoundedRectangle(cornerRadius: 10)
          .strokeBorder(Color(uiColor: .init(hex: "#EBEBEB")), lineWidth: 1)
      )

      
      // 이벤트 장소
      HStack(spacing: 0) {
        Spacer().frame(width: 12)
        VStack(alignment: .leading, spacing: 4) {
          Image(.iconPinLine)
            .renderingMode(.template)
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(PND.DS.commonBlack)
          
          Text("참가 비용")
            .font(.system(size: 14, weight: .bold))
            .lineLimit(1)
          
          Text("무료")
            .font(.system(size: 12, weight: .regular))
            .lineLimit(1)
        }
        .padding(.vertical, 12)
        Spacer(minLength: 12)
      }
      .background(
        RoundedRectangle(cornerRadius: 10)
          .strokeBorder(Color(uiColor: .init(hex: "#EBEBEB")), lineWidth: 1)
      )
    }
  }
  
  
  @ViewBuilder
  private var eventLocationView: some View {
    HStack(spacing: 0) {
      Spacer().frame(width: 12)
      VStack(alignment: .leading, spacing: 4) {
        Image(.iconCalendar)
          .renderingMode(.template)
          .resizable()
          .frame(width: 24, height: 24)
          .foregroundStyle(PND.DS.commonBlack)
        
        Text("서울시 강서구 멍냥로 12")
          .font(.system(size: 14, weight: .bold))
          .lineLimit(1)
        
        Text("상가 1층 건물 앞에 모여서 만나요")
          .font(.system(size: 12, weight: .regular))
          .lineLimit(1)
      }
      .padding(.vertical, 12)
      
      Spacer(minLength: 12)
    }
    .background(
      RoundedRectangle(cornerRadius: 10)
        .strokeBorder(Color(uiColor: .init(hex: "#EBEBEB")), lineWidth: 1)
    )
  }
  
  
  // 이벤트 몇 회 진행됐는지
  @ViewBuilder
  private var eventProgressView: some View {
    HStack {
      Spacer()
      VStack(spacing: 2) {
        
        Group {
          Text("이벤트가 지금까지") +
          Text(" 3회 ")
            .foregroundStyle(PND.DS.primary)
          
          +
          Text("진행됐어요!")
        }
        .font(.system(size: 14, weight: .semibold))
        
        Text("최근 진행일 : 2024년 3월")
          .font(.system(size: 12, weight: .regular))
          .foregroundStyle(PND.DS.gray50)
      }
      Spacer()
    }
  }
  
  @ViewBuilder
  private var joinChatArea: some View {
    VStack {
      Spacer()
      
      Button {
        
      } label: {
        RoundedRectangle(cornerRadius: 4)
          .foregroundStyle(PND.Colors.primary.asColor)
          .overlay(
            Text("이벤트 채팅 참여하기")
              .font(.system(size: CGFloat(20), weight: .bold))
              .foregroundStyle(.white)
          )
          .frame(height: CGFloat(60))
          .padding(.horizontal, PND.Metrics.defaultSpacing)
        
      }
      .buttonStyle(ScaleEffectButtonStyle())
      
      
      Spacer().frame(height: 50)
    }
  }
}

#Preview {
  EventDetailView(store: .init(initialState: .init(), reducer: { EventDetailFeature() }))
}
